import Foundation

/// Converts compensated sensor current values into calibrated cortisol
/// concentrations (ng/mL), manages personal calibration points, and
/// re-fits the calibration curve from user-supplied saliva test data.
class CalibrationEngine: ObservableObject {

    @Published var profile: CalibrationProfile

    init(profile: CalibrationProfile) {
        self.profile = profile
    }

    // MARK: - Concentration Conversion

    /// Converts a fully compensated current value to a cortisol concentration.
    ///
    /// Uses a log-linear model derived from the calibration guide:
    ///   deltaI    = baseline − compensatedUA   (signal change from zero-cortisol)
    ///   log10(C)  = slope × deltaI + intercept
    ///   labConc   = 10^(log10(C))
    ///
    /// A positive deltaI is required for a valid cortisol signal (the biosensor
    /// current decreases as cortisol binds to the aptamer). Zero or negative
    /// deltaI means no detectable signal change, so 0 is returned.
    ///
    /// Personal calibration is then applied:
    ///   result = labConc × personalScale + personalOffset
    ///
    /// - Parameter compensatedUA: Sensor-fusion-compensated current (µA)
    /// - Returns: Estimated cortisol concentration (ng/mL), 0 when no signal
    func rawToConcentration(compensatedUA: Float) -> Float {
        let deltaI = profile.baseline - compensatedUA
        guard deltaI > 0 else { return 0 }  // No signal change = no cortisol
        let logConc = profile.slope * deltaI + profile.intercept
        let labConc = pow(10, logConc)
        // Apply personal calibration
        return labConc * profile.personalScale + profile.personalOffset
    }

    // MARK: - Confidence Estimation

    /// Estimates measurement confidence based on contact quality, GSR level,
    /// and temperature validity.
    ///
    /// Confidence components (multiplicative):
    ///   - contactScore: linear normalisation of contactQuality (0–100 → 0–1)
    ///   - temperature penalty: ×0.7 if outside physiological range 20–37 °C
    ///   - GSR penalty: ×0.5 if skin too dry (gsrUS < 0.5 µS)
    ///
    /// - Parameter reading: The raw SensorReading to evaluate
    /// - Returns: Confidence value clamped to [0.0, 1.0]
    func calculateConfidence(reading: SensorReading) -> Float {
        var score: Float = 1.0

        // Contact quality (linear scale)
        score *= Float(reading.contactQuality) / 100.0

        // Temperature penalty: outside 20–37 °C range
        if reading.temperatureC < 20 || reading.temperatureC > 37 {
            score *= 0.7
        }

        // GSR too low (dry skin, not enough sweat)
        if reading.gsrUS < 0.5 {
            score *= 0.5
        }

        return max(0, min(1, score))
    }

    // MARK: - Calibration Point Management

    /// Records a new saliva-test calibration point.
    ///
    /// - Parameters:
    ///   - rawUA: The raw current reading at the moment of the saliva test (µA)
    ///   - knownConcentration: Cortisol concentration from the saliva test kit (ng/mL)
    func addCalibrationPoint(rawUA: Float, knownConcentration: Float) {
        let point = CalibrationPoint(rawUA: rawUA, knownConcentration: knownConcentration)
        var points = profile.calibrationPoints
        points.append(point)
        profile.calibrationPoints = points
    }

    // MARK: - Curve Refitting

    /// Refits the personal calibration scale and offset using all accumulated
    /// saliva-test calibration points via ordinary least-squares regression.
    ///
    /// - If >= 2 points: full OLS linear regression fitting
    ///     knownConcentration = personalScale × predicted + personalOffset
    /// - If 1 point: simple ratio adjustment (personalOffset reset to 0)
    /// - If 0 points: no-op
    ///
    /// The regression operates in concentration space: predicted values come
    /// from rawToConcentration() so the personal scale and offset absorb any
    /// remaining systematic error between device and lab reference.
    func recalibrate() {
        let points = profile.calibrationPoints
        guard !points.isEmpty else { return }

        if points.count == 1 {
            // Single point: adjust personal scale
            let point = points[0]
            let predicted = rawToConcentration(compensatedUA: point.rawUA)
            if predicted > 0 {
                profile.personalScale = point.knownConcentration / predicted
                profile.personalOffset = 0
            }
        } else {
            // OLS: fit knownConc = scale * predictedConc + offset
            let predicted = points.map { rawToConcentration(compensatedUA: $0.rawUA) }
            let known = points.map { $0.knownConcentration }

            let n = Float(points.count)
            let sumX  = predicted.reduce(0, +)
            let sumY  = known.reduce(0, +)
            let sumXY = zip(predicted, known).map(*).reduce(0, +)
            let sumX2 = predicted.map { $0 * $0 }.reduce(0, +)

            let denom = n * sumX2 - sumX * sumX
            guard abs(denom) > 1e-10 else { return }

            profile.personalScale  = (n * sumXY - sumX * sumY) / denom
            profile.personalOffset = (sumY - profile.personalScale * sumX) / n
        }
    }

    // MARK: - Full Pipeline

    /// Convenience method: runs sensor fusion compensation then converts to ng/mL.
    ///
    /// Processing order:
    ///   1. NIP differential — subtracts non-specific signal from MIP reading
    ///   2. Temperature compensation
    ///   3. Humidity compensation
    ///   4. Sweat rate normalization
    ///   5. Concentration conversion via log-linear calibration curve
    ///
    /// - Parameter reading: Raw SensorReading from the BLE device
    /// - Returns: A CalibratedReading with cortisol concentration and confidence
    func process(reading: SensorReading) -> CalibratedReading {
        let compensated = SensorFusion.compensate(
            rawUA: reading.cortisolRawUA,
            nipRawUA: reading.nipRawUA,
            tempC: reading.temperatureC,
            humidityPct: reading.humidityPct,
            gsrUS: reading.gsrUS,
            profile: profile
        )
        let concentration = rawToConcentration(compensatedUA: compensated)
        let confidence    = calculateConfidence(reading: reading)
        return CalibratedReading(
            sensorReading: reading,
            cortisolNgMl: concentration,
            confidence: confidence
        )
    }
}

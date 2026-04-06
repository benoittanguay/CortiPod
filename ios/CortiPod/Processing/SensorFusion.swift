import Foundation

/// Applies multi-factor environmental compensation to raw cortisol current readings.
///
/// All compensation functions follow the linear correction models defined in the
/// CortiPod calibration guide. The goal is to return the equivalent current that
/// would have been measured under reference conditions.
enum SensorFusion {

    // MARK: - NIP Differential Correction

    /// Subtract NIP signal from MIP signal to get cortisol-specific response.
    /// MIP signal = cortisol (specific) + interferents (non-specific)
    /// NIP signal = interferents only (no specific binding)
    /// Differential = MIP - NIP = cortisol-specific signal
    static func nipDifferential(mipRawUA: Float, nipRawUA: Float) -> Float {
        return mipRawUA - nipRawUA
    }

    // MARK: - Temperature Compensation

    /// Corrects a raw current reading for temperature deviation from calibration.
    ///
    /// The electrochemical reaction rate of the aptamer-based sensor follows an
    /// Arrhenius-like linear approximation over the physiological range (20–40 °C).
    /// Calibration guide coefficient: ~2.5% change per °C.
    ///
    /// Formula: compensated = rawUA / (1 + 0.025 * (tempC - refTempC))
    ///
    /// - Parameters:
    ///   - rawUA: Raw current reading from the potentiostat (µA)
    ///   - tempC: Measured skin-proximal temperature (°C)
    ///   - refTempC: Temperature during lab calibration (°C, default 25.0)
    /// - Returns: Temperature-compensated current (µA)
    static func temperatureCompensate(rawUA: Float, tempC: Float, refTempC: Float = 25.0) -> Float {
        let tempCoeff: Float = 0.025
        let correction = 1.0 + tempCoeff * (tempC - refTempC)
        return rawUA / correction
    }

    // MARK: - Humidity Compensation

    /// Corrects a raw current reading for ambient humidity deviation.
    ///
    /// Low humidity causes sweat to evaporate faster, concentrating cortisol at the
    /// sensor surface and producing an artificially high reading. Multiplying by the
    /// correction factor scales the reading back toward the reference condition.
    /// Calibration guide coefficient: ±0.5% per 1% RH deviation from 50% RH.
    ///
    /// Formula: compensated = rawUA * (1 + 0.005 * (humidityPct - refHumidityPct))
    ///
    /// - Parameters:
    ///   - rawUA: Temperature-compensated current reading (µA)
    ///   - humidityPct: Measured relative humidity (%)
    ///   - refHumidityPct: Humidity during lab calibration (%, default 50.0)
    /// - Returns: Humidity-compensated current (µA)
    static func humidityCompensate(rawUA: Float, humidityPct: Float, refHumidityPct: Float = 50.0) -> Float {
        let humCoeff: Float = 0.005
        let correction = 1.0 + humCoeff * (humidityPct - refHumidityPct)
        return rawUA * correction
    }

    // MARK: - GSR / Sweat Normalization

    /// Normalizes a current reading for variations in sweat rate using GSR.
    ///
    /// More sweat means more dilute cortisol at the sensor surface. Scaling by the
    /// ratio of current GSR to reference GSR corrects for this dilution effect.
    ///
    /// Formula: compensated = rawUA * (gsrUS / refGSR)
    ///
    /// - Parameters:
    ///   - rawUA: Humidity-compensated current reading (µA)
    ///   - gsrUS: Measured skin conductance (µS)
    ///   - refGSR: GSR during lab calibration (µS)
    /// - Returns: Sweat-normalized current (µA)
    static func sweatNormalize(rawUA: Float, gsrUS: Float, refGSR: Float) -> Float {
        guard refGSR > 0 else { return rawUA }
        return rawUA * (gsrUS / refGSR)
    }

    // MARK: - Combined Pipeline

    /// Runs the full compensation pipeline:
    ///   1. NIP differential (remove non-specific signal)
    ///   2. Temperature compensation
    ///   3. Humidity compensation
    ///   4. Sweat rate normalization
    ///
    /// - Parameters:
    ///   - rawUA: Raw MIP current reading from the potentiostat (µA)
    ///   - nipRawUA: Raw NIP (reference electrode) current reading (µA)
    ///   - tempC: Measured skin-proximal temperature (°C)
    ///   - humidityPct: Measured relative humidity (%)
    ///   - gsrUS: Measured skin conductance (µS)
    ///   - profile: Calibration profile containing reference conditions
    /// - Returns: Fully compensated current value (µA)
    static func compensate(rawUA: Float, nipRawUA: Float, tempC: Float, humidityPct: Float, gsrUS: Float, profile: CalibrationProfile) -> Float {
        var compensated = nipDifferential(mipRawUA: rawUA, nipRawUA: nipRawUA)
        compensated = temperatureCompensate(rawUA: compensated, tempC: tempC, refTempC: profile.referenceTemperatureC)
        compensated = humidityCompensate(rawUA: compensated, humidityPct: humidityPct)
        compensated = sweatNormalize(rawUA: compensated, gsrUS: gsrUS, refGSR: profile.referenceGSR)
        return compensated
    }
}

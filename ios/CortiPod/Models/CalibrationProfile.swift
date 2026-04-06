import Foundation
import SwiftData

/// A single known-concentration data point used to fit the calibration curve.
struct CalibrationPoint: Codable {
    /// Raw current reading at the time of the saliva test (microamps)
    var rawUA: Float
    /// Known cortisol concentration from the reference test (ng/mL)
    var knownConcentration: Float
    /// Timestamp of the calibration point
    var capturedAt: Date

    init(rawUA: Float, knownConcentration: Float, capturedAt: Date = Date()) {
        self.rawUA = rawUA
        self.knownConcentration = knownConcentration
        self.capturedAt = capturedAt
    }
}

@Model
final class CalibrationProfile {
    var id: UUID
    var createdAt: Date

    // MARK: - Lab Calibration Curve (linear: y = slope * x + intercept)
    /// Slope from the lab calibration curve (ng/mL per µA)
    var slope: Float
    /// Intercept from the lab calibration curve (ng/mL)
    var intercept: Float
    /// Zero-cortisol baseline current (µA)
    var baseline: Float

    // MARK: - Personal Calibration (applied after lab curve)
    /// Multiplicative scale factor from saliva test calibration (default 1.0)
    var personalScale: Float
    /// Additive offset from saliva test calibration (default 0.0, ng/mL)
    var personalOffset: Float

    // MARK: - Environmental Reference Conditions
    /// Temperature at the time of calibration (°C, default 25.0)
    var referenceTemperatureC: Float
    /// GSR reading at the time of calibration (µS)
    var referenceGSR: Float

    // MARK: - Calibration Points
    /// Serialized as JSON because SwiftData does not yet support [Struct] natively
    private var calibrationPointsData: Data

    var calibrationPoints: [CalibrationPoint] {
        get {
            (try? JSONDecoder().decode([CalibrationPoint].self, from: calibrationPointsData)) ?? []
        }
        set {
            calibrationPointsData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        slope: Float = 1.0,
        intercept: Float = 0.0,
        baseline: Float = 0.0,
        personalScale: Float = 1.0,
        personalOffset: Float = 0.0,
        referenceTemperatureC: Float = 25.0,
        referenceGSR: Float = 10.0
    ) {
        self.id = id
        self.createdAt = createdAt
        self.slope = slope
        self.intercept = intercept
        self.baseline = baseline
        self.personalScale = personalScale
        self.personalOffset = personalOffset
        self.referenceTemperatureC = referenceTemperatureC
        self.referenceGSR = referenceGSR
        self.calibrationPointsData = Data()
    }
}

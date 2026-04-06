import Foundation

/// A post-processed reading derived from a raw SensorReading.
/// Not persisted via SwiftData — computed on demand.
struct CalibratedReading {
    /// The underlying raw sensor reading
    let sensorReading: SensorReading
    /// Calibrated cortisol concentration in ng/mL
    let cortisolNgMl: Float
    /// Confidence score from 0.0 (no confidence) to 1.0 (full confidence)
    let confidence: Float

    var timestamp: Date { sensorReading.timestamp }

    /// Returns true when the reading meets a minimum confidence threshold.
    var isReliable: Bool { confidence >= 0.6 }

    /// Human-readable cortisol level category based on typical diurnal ranges.
    var levelCategory: CortisolLevel {
        switch cortisolNgMl {
        case ..<5:   return .low
        case 5..<15: return .normal
        case 15..<25: return .elevated
        default:     return .high
        }
    }
}

enum CortisolLevel: String {
    case low      = "Low"
    case normal   = "Normal"
    case elevated = "Elevated"
    case high     = "High"

    var description: String {
        switch self {
        case .low:      return "Below typical range"
        case .normal:   return "Within normal range"
        case .elevated: return "Above normal range"
        case .high:     return "Significantly elevated"
        }
    }
}

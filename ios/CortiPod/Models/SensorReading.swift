import Foundation
import SwiftData

@Model
final class SensorReading {
    var id: UUID
    var timestamp: Date
    /// Raw current in microamps from MIP (molecularly imprinted polymer) electrode
    var cortisolRawUA: Float
    /// Raw current in microamps from NIP (non-imprinted polymer) reference electrode
    var nipRawUA: Float
    /// Temperature from TMP117 in degrees Celsius
    var temperatureC: Float
    /// Relative humidity from SHT40 in percent
    var humidityPct: Float
    /// Skin conductance in microsiemens from GSR sensor
    var gsrUS: Float
    /// Contact quality score 0–100
    var contactQuality: UInt8

    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        cortisolRawUA: Float,
        nipRawUA: Float,
        temperatureC: Float,
        humidityPct: Float,
        gsrUS: Float,
        contactQuality: UInt8
    ) {
        self.id = id
        self.timestamp = timestamp
        self.cortisolRawUA = cortisolRawUA
        self.nipRawUA = nipRawUA
        self.temperatureC = temperatureC
        self.humidityPct = humidityPct
        self.gsrUS = gsrUS
        self.contactQuality = contactQuality
    }
}

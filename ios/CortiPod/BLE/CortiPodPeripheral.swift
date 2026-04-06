import Foundation
import CoreBluetooth

/// Represents a discovered CortiPod peripheral before a full BLE connection is
/// established. Used by the scanning UI to display candidate devices.
struct CortiPodPeripheral: Identifiable {
    let id: UUID
    let peripheral: CBPeripheral
    let advertisedName: String
    let rssi: Int

    init(peripheral: CBPeripheral, advertisementData: [String: Any], rssi: Int) {
        self.id = peripheral.identifier
        self.peripheral = peripheral
        self.advertisedName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
            ?? peripheral.name
            ?? "CortiPod"
        self.rssi = rssi
    }

    /// A human-readable signal strength label derived from the RSSI value.
    var signalStrengthLabel: String {
        switch rssi {
        case -50...:          return "Excellent"
        case -70 ..< -50:     return "Good"
        case -85 ..< -70:     return "Fair"
        default:              return "Weak"
        }
    }

    /// An SF Symbol name appropriate for the current signal strength.
    var signalStrengthSymbol: String {
        switch rssi {
        case -50...:          return "wifi"
        case -70 ..< -50:     return "wifi"
        case -85 ..< -70:     return "wifi.exclamationmark"
        default:              return "wifi.slash"
        }
    }
}

// MARK: - Device Status Flags

/// Decoded representation of the firmware's status bitmask
/// (BLE_CHAR_STATUS_UUID, `config.h` STATUS_FLAG_* constants).
struct CortiPodStatus {
    let rawValue: UInt8

    /// BLE connection flag set by the firmware itself.
    var isBLEConnected: Bool    { rawValue & (1 << 0) != 0 }
    /// Whether the sensor electrodes detect skin contact.
    var hasSkinContact: Bool    { rawValue & (1 << 1) != 0 }
    /// A measurement cycle is actively in progress.
    var isMeasuring: Bool       { rawValue & (1 << 2) != 0 }
    /// Battery is below the low-battery threshold.
    var isLowBattery: Bool      { rawValue & (1 << 3) != 0 }
    /// A sensor error has been detected.
    var hasSensorError: Bool    { rawValue & (1 << 4) != 0 }

    init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
}

// MARK: - Packet Parsing Helpers

/// Stateless helpers for decoding raw BLE characteristic bytes into Swift values.
/// All multi-byte values are little-endian, matching the nRF52832 firmware.
enum CortiPodPacketParser {

    /// Decodes a 4-byte little-endian IEEE 754 Float32.
    static func parseFloat(_ data: Data) -> Float? {
        guard data.count >= 4 else { return nil }
        return data.withUnsafeBytes { $0.load(as: Float.self) }
    }

    /// Decodes a single unsigned byte.
    static func parseUInt8(_ data: Data) -> UInt8? {
        data.first
    }

    /// Decodes a 2-byte little-endian UInt16.
    static func parseUInt16(_ data: Data) -> UInt16? {
        guard data.count >= 2 else { return nil }
        return data.withUnsafeBytes { $0.load(as: UInt16.self) }
    }

    /// Decodes a 2-byte little-endian Int16.
    static func parseInt16(_ data: Data) -> Int16? {
        guard data.count >= 2 else { return nil }
        return data.withUnsafeBytes { $0.load(as: Int16.self) }
    }

    /// Decodes a 4-byte little-endian UInt32.
    static func parseUInt32(_ data: Data) -> UInt32? {
        guard data.count >= 4 else { return nil }
        return data.withUnsafeBytes { $0.load(as: UInt32.self) }
    }

    /// Decodes the temperature characteristic (Int16, degrees C × 100) into
    /// a Float in degrees Celsius.
    static func parseTemperatureC(_ data: Data) -> Float? {
        guard let raw = parseInt16(data) else { return nil }
        return Float(raw) / 100.0
    }

    /// Decodes the humidity characteristic (UInt16, % × 100) into a Float
    /// representing relative humidity in percent.
    static func parseHumidityPct(_ data: Data) -> Float? {
        guard let raw = parseUInt16(data) else { return nil }
        return Float(raw) / 100.0
    }

    /// Decodes the GSR characteristic (UInt32, ohms) and converts to
    /// conductance in microsiemens (µS = 1/R × 10⁶).
    /// Returns 0 when resistance is zero to avoid division by zero.
    static func parseGSRMicrosiemens(_ data: Data) -> Float? {
        guard let ohms = parseUInt32(data) else { return nil }
        return ohms > 0 ? 1_000_000.0 / Float(ohms) : 0
    }

    /// Decodes the status characteristic byte into a `CortiPodStatus` struct.
    static func parseStatus(_ data: Data) -> CortiPodStatus? {
        guard let raw = parseUInt8(data) else { return nil }
        return CortiPodStatus(rawValue: raw)
    }

    /// Decodes a full combined measurement packet when the firmware sends all
    /// fields in a single notification (alternative to per-characteristic
    /// notifications). Expected layout (13 bytes):
    ///
    ///   [0..3]  cortisolRawUA  Float32 LE  — mean chrono current (µA)
    ///   [4..5]  temperatureC   Int16  LE   — degrees C × 100
    ///   [6..7]  humidityPct    UInt16 LE   — % × 100
    ///   [8..11] gsrOhms        UInt32 LE   — resistance in ohms
    ///   [12]    statusFlags    UInt8       — STATUS_FLAG_* bitmask
    static func parseCombinedPacket(_ data: Data) -> SensorReading? {
        guard data.count >= 13 else { return nil }

        let rawUA   = data[0..<4].withUnsafeBytes { $0.load(as: Float.self) }
        let tempRaw = data[4..<6].withUnsafeBytes { $0.load(as: Int16.self) }
        let humRaw  = data[6..<8].withUnsafeBytes { $0.load(as: UInt16.self) }
        let gsrOhms = data[8..<12].withUnsafeBytes { $0.load(as: UInt32.self) }
        let contact = data[12]

        let gsrUS: Float = gsrOhms > 0 ? 1_000_000.0 / Float(gsrOhms) : 0

        return SensorReading(
            cortisolRawUA:  rawUA,
            nipRawUA:       0,  // Legacy combined packet predates dual-electrode; NIP comes via its own characteristic
            temperatureC:   Float(tempRaw) / 100.0,
            humidityPct:    Float(humRaw)  / 100.0,
            gsrUS:          gsrUS,
            contactQuality: contact
        )
    }
}

import Foundation
import CoreBluetooth
import Combine

// MARK: - Service & Characteristic UUIDs
// Must match the GATT configuration in the CortiPod firmware (config.h).

extension CBUUID {
    // Primary CortiPod Measurement Service
    static let cortiPodService    = CBUUID(string: "12340001-0000-1000-8000-00805F9B34FB")

    // Measurement characteristics
    static let chronoData         = CBUUID(string: "12340002-0000-1000-8000-00805F9B34FB")
    static let temperature        = CBUUID(string: "12340003-0000-1000-8000-00805F9B34FB")
    static let humidity           = CBUUID(string: "12340004-0000-1000-8000-00805F9B34FB")
    static let gsr                = CBUUID(string: "12340005-0000-1000-8000-00805F9B34FB")
    static let sensorStatus       = CBUUID(string: "12340006-0000-1000-8000-00805F9B34FB")
    static let command            = CBUUID(string: "12340007-0000-1000-8000-00805F9B34FB")
    static let nipChronoData      = CBUUID(string: "12340008-0000-1000-8000-00805F9B34FB")
}

// MARK: - BLEManager

/// Central manager for the CortiPod BLE connection.
///
/// Responsibilities:
///   - Scanning for and connecting to the CortiPod peripheral
///   - Discovering GATT services and characteristics
///   - Subscribing to notifications for live sensor data
///   - Writing command bytes (measurement trigger, reset, sleep)
///   - Publishing state to SwiftUI views via @Published properties
///   - Auto-reconnecting after an unexpected disconnect
///   - Tracking RSSI every 5 seconds while connected
///   - Buffering completed SensorReadings when no SwiftData context is ready
@MainActor
final class BLEManager: NSObject, ObservableObject {

    // MARK: - Published State

    @Published private(set) var isScanning: Bool = false
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var deviceName: String = "No Device"
    @Published private(set) var latestReading: SensorReading?
    @Published private(set) var sensorStatus: UInt8 = 0
    @Published private(set) var connectionError: String?

    /// Signal strength of the connected peripheral, updated every 5 seconds.
    @Published var rssi: Int = 0

    /// Battery level percentage (0–100), or -1 when unavailable.
    @Published private(set) var batteryLevel: Int = -1

    /// Most-recent NIP (non-imprinted polymer) raw current mean (µA), or nil before the first reading.
    @Published private(set) var latestNipRawUA: Float?

    /// Readings assembled while no active SwiftData context is available.
    /// Consumers should drain this array into persistent storage when a
    /// ModelContext becomes available.
    @Published var bufferedReadings: [SensorReading] = []

    // MARK: - Private State

    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?

    /// Discovered characteristics keyed by UUID for fast lookup.
    private var characteristics: [CBUUID: CBCharacteristic] = [:]

    // Accumulated values from individual notify characteristics.
    // A SensorReading is assembled once all three environmental values arrive
    // (chrono data is handled separately as a streaming array).
    private var pendingTempC: Float?
    private var pendingHumidityPct: Float?
    private var pendingGSRUS: Float?

    /// Chrono current samples accumulated during a measurement window.
    private var chronoSamples: [Float] = []

    /// NIP chrono current samples accumulated during the same measurement window.
    private var nipChronoSamples: [Float] = []

    /// Timer that fires every 5 seconds to request an RSSI update.
    private var rssiTimer: Timer?

    /// Whether the disconnect was user-initiated (suppresses auto-reconnect).
    private var userInitiatedDisconnect: Bool = false

    // MARK: - Init

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // MARK: - Public API

    func startScanning() {
        guard centralManager.state == .poweredOn, !isScanning else { return }
        isScanning = true
        connectionError = nil
        centralManager.scanForPeripherals(
            withServices: [.cortiPodService],
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
        )
    }

    func stopScanning() {
        guard isScanning else { return }
        centralManager.stopScan()
        isScanning = false
    }

    func connect(to peripheral: CBPeripheral) {
        self.peripheral = peripheral
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
        stopScanning()
    }

    /// Disconnects the current peripheral. Sets the user-initiated flag so that
    /// auto-reconnect is suppressed.
    func disconnect() {
        guard let peripheral else { return }
        userInitiatedDisconnect = true
        centralManager.cancelPeripheralConnection(peripheral)
    }

    /// Writes the measurement-trigger command (0x01) to the Command characteristic.
    func triggerMeasurement() {
        writeCommand(0x01)
    }

    /// Writes the device-reset command (0x02).
    func resetDevice() {
        writeCommand(0x02)
    }

    /// Writes the enter-sleep command (0x03).
    func enterSleep() {
        writeCommand(0x03)
    }

    // MARK: - Private Helpers

    private func writeCommand(_ byte: UInt8) {
        guard
            isConnected,
            let characteristic = characteristics[.command]
        else { return }
        let data = Data([byte])
        peripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }

    /// Attempts to assemble a SensorReading from the three pending environmental
    /// values. Called each time a new value arrives; does nothing until all three
    /// are present. On completion the pending values are cleared.
    ///
    /// Note: `cortisolRawUA` is derived from the mean of the accumulated chrono
    /// current samples collected during the most-recent measurement window.
    private func assembleReadingIfComplete() {
        guard
            let tempC    = pendingTempC,
            let humidity = pendingHumidityPct,
            let gsr      = pendingGSRUS
        else { return }

        // Derive a single MIP proxy value from the chrono current array.
        let cortisolRawUA: Float
        if chronoSamples.isEmpty {
            cortisolRawUA = 0
        } else {
            cortisolRawUA = chronoSamples.reduce(0, +) / Float(chronoSamples.count)
        }

        // Derive a single NIP proxy value from the NIP chrono current array.
        let nipRawUA: Float
        if nipChronoSamples.isEmpty {
            nipRawUA = 0
        } else {
            nipRawUA = nipChronoSamples.reduce(0, +) / Float(nipChronoSamples.count)
        }
        latestNipRawUA = nipRawUA

        let reading = SensorReading(
            cortisolRawUA:  cortisolRawUA,
            nipRawUA:       nipRawUA,
            temperatureC:   tempC,
            humidityPct:    humidity,
            gsrUS:          gsr,
            contactQuality: 0   // No dedicated contact-quality characteristic in firmware
        )

        latestReading = reading
        bufferedReadings.append(reading)

        // Reset accumulators
        pendingTempC       = nil
        pendingHumidityPct = nil
        pendingGSRUS       = nil
        chronoSamples.removeAll()
        nipChronoSamples.removeAll()
    }

    /// Decodes a raw BLE characteristic payload and updates the corresponding
    /// pending field, then attempts assembly. Data formats match the firmware:
    ///   - chronoData  : 4-byte LE Float32 per sample (streaming)
    ///   - temperature : 2-byte LE Int16, value = degrees C × 100
    ///   - humidity    : 2-byte LE UInt16, value = % × 100
    ///   - gsr         : 4-byte LE UInt32, value = resistance in ohms
    ///   - sensorStatus: 1-byte bitmask
    private func parseValue(_ data: Data, for uuid: CBUUID) {
        switch uuid {
        case .chronoData:
            // Each notification carries one Float32 current sample (µA).
            if let sample = CortiPodPacketParser.parseFloat(data) {
                chronoSamples.append(sample)
            }
            // Do not call assembleReadingIfComplete here — chrono data streams
            // throughout the measurement; environmental values arrive at the end.

        case .nipChronoData:
            // Each notification carries one Float32 NIP current sample (µA).
            if let sample = CortiPodPacketParser.parseFloat(data) {
                nipChronoSamples.append(sample)
            }
            // Same as MIP: do not trigger assembly here.

        case .temperature:
            guard data.count >= 2 else { return }
            let raw = data.withUnsafeBytes { $0.load(as: Int16.self) }
            pendingTempC = Float(raw) / 100.0
            assembleReadingIfComplete()

        case .humidity:
            guard data.count >= 2 else { return }
            let raw = data.withUnsafeBytes { $0.load(as: UInt16.self) }
            pendingHumidityPct = Float(raw) / 100.0
            assembleReadingIfComplete()

        case .gsr:
            guard data.count >= 4 else { return }
            let raw = data.withUnsafeBytes { $0.load(as: UInt32.self) }
            // Convert resistance (ohms) to conductance (µS): G = 1/R × 10⁶
            pendingGSRUS = raw > 0 ? 1_000_000.0 / Float(raw) : 0
            assembleReadingIfComplete()

        case .sensorStatus:
            sensorStatus = data.first ?? 0

        default:
            break
        }
    }

    // MARK: - RSSI Timer

    private func startRSSITimer() {
        stopRSSITimer()
        rssiTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.peripheral?.readRSSI()
            }
        }
    }

    private func stopRSSITimer() {
        rssiTimer?.invalidate()
        rssiTimer = nil
    }

    // MARK: - Auto-Reconnect

    private func scheduleAutoReconnect() {
        Task { @MainActor in
            // Brief delay to avoid hammering the radio immediately after disconnect.
            try? await Task.sleep(for: .seconds(2))
            guard !isConnected, !isScanning else { return }
            startScanning()
        }
    }
}

// MARK: - CBCentralManagerDelegate

extension BLEManager: CBCentralManagerDelegate {

    nonisolated func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Task { @MainActor in
            switch central.state {
            case .poweredOn:
                connectionError = nil
            case .poweredOff:
                isConnected = false
                connectionError = "Bluetooth is turned off."
            case .unauthorized:
                connectionError = "Bluetooth access not authorized."
            case .unsupported:
                connectionError = "Bluetooth LE not supported on this device."
            default:
                break
            }
        }
    }

    nonisolated func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        Task { @MainActor in
            connect(to: peripheral)
        }
    }

    nonisolated func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral
    ) {
        Task { @MainActor in
            isConnected = true
            deviceName = peripheral.name ?? "CortiPod"
            userInitiatedDisconnect = false
            characteristics.removeAll()
            peripheral.discoverServices([.cortiPodService])
            startRSSITimer()
        }
    }

    nonisolated func centralManager(
        _ central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: Error?
    ) {
        Task { @MainActor in
            isConnected = false
            deviceName = "No Device"
            rssi = 0
            characteristics.removeAll()
            self.peripheral = nil
            stopRSSITimer()

            let wasUserInitiated = userInitiatedDisconnect
            userInitiatedDisconnect = false

            if let error {
                connectionError = error.localizedDescription
            }

            // Auto-reconnect only for unexpected disconnects.
            if !wasUserInitiated {
                scheduleAutoReconnect()
            }
        }
    }

    nonisolated func centralManager(
        _ central: CBCentralManager,
        didFailToConnect peripheral: CBPeripheral,
        error: Error?
    ) {
        Task { @MainActor in
            connectionError = error?.localizedDescription ?? "Failed to connect."
            self.peripheral = nil
        }
    }
}

// MARK: - CBPeripheralDelegate

extension BLEManager: CBPeripheralDelegate {

    nonisolated func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: Error?
    ) {
        guard let services = peripheral.services else { return }
        for service in services {
            if service.uuid == .cortiPodService {
                peripheral.discoverCharacteristics(
                    [.chronoData, .nipChronoData, .temperature, .humidity, .gsr, .sensorStatus, .command],
                    for: service
                )
            }
        }
    }

    nonisolated func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?
    ) {
        guard let chars = service.characteristics else { return }
        Task { @MainActor in
            for char in chars {
                characteristics[char.uuid] = char
                // Subscribe to notifications for all notify-capable characteristics.
                if char.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: char)
                }
            }
        }
    }

    nonisolated func peripheral(
        _ peripheral: CBPeripheral,
        didUpdateValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        guard error == nil, let data = characteristic.value else { return }
        Task { @MainActor in
            parseValue(data, for: characteristic.uuid)
        }
    }

    nonisolated func peripheral(
        _ peripheral: CBPeripheral,
        didWriteValueFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        if let error {
            Task { @MainActor in
                connectionError = "Write failed: \(error.localizedDescription)"
            }
        }
    }

    nonisolated func peripheral(
        _ peripheral: CBPeripheral,
        didReadRSSI RSSI: NSNumber,
        error: Error?
    ) {
        guard error == nil else { return }
        Task { @MainActor in
            rssi = RSSI.intValue
        }
    }
}

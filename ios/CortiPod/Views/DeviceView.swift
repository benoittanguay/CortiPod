import SwiftUI

/// Displays BLE connection status, battery level, and live sensor diagnostics.
struct DeviceView: View {
    @EnvironmentObject private var bleManager: BLEManager
    @State private var showForgetAlert: Bool = false

    var body: some View {
        NavigationStack {
            List {
                connectionSection
                deviceInfoSection
                sensorDataSection
                actionsSection
            }
            .navigationTitle("Device")
            .navigationBarTitleDisplayMode(.large)
            .listStyle(.insetGrouped)
        }
    }

    // MARK: - Sections

    private var connectionSection: some View {
        Section("Connection") {
            HStack {
                Label {
                    Text("Status")
                } icon: {
                    Image(systemName: bleManager.isConnected
                          ? "sensor.tag.radiowaves.forward.fill"
                          : "sensor.tag.radiowaves.forward")
                    .foregroundStyle(bleManager.isConnected ? .green : .secondary)
                }
                Spacer()
                Text(bleManager.isConnected ? "Connected" : "Disconnected")
                    .foregroundStyle(bleManager.isConnected ? .green : .secondary)
                    .font(.subheadline)
            }

            if bleManager.isConnected {
                Button(role: .destructive) {
                    bleManager.disconnect()
                } label: {
                    Label("Disconnect", systemImage: "xmark.circle.fill")
                }
            } else {
                Button {
                    bleManager.startScanning()
                } label: {
                    Label(
                        bleManager.isScanning ? "Scanning…" : "Scan for Device",
                        systemImage: bleManager.isScanning ? "antenna.radiowaves.left.and.right" : "magnifyingglass"
                    )
                }
                .disabled(bleManager.isScanning)
            }

            if let error = bleManager.connectionError {
                Label(error, systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
    }

    private var deviceInfoSection: some View {
        Section("Device Info") {
            infoRow(
                label: "Name",
                value: bleManager.deviceName,
                icon: "tag.fill",
                color: .indigo
            )
            infoRow(
                label: "Battery",
                value: bleManager.batteryLevel >= 0
                    ? "\(bleManager.batteryLevel)%"
                    : "--",
                icon: batteryIcon,
                color: batteryColor
            )
        }
    }

    private var sensorDataSection: some View {
        Section("Live Sensor Data") {
            if let reading = bleManager.latestReading {
                infoRow(
                    label: "Raw Current",
                    value: String(format: "%.4f µA", reading.cortisolRawUA),
                    icon: "waveform.path",
                    color: .purple
                )
                infoRow(
                    label: "Temperature",
                    value: String(format: "%.1f °C", reading.temperatureC),
                    icon: "thermometer.medium",
                    color: .orange
                )
                infoRow(
                    label: "Humidity",
                    value: String(format: "%.0f%%", reading.humidityPct),
                    icon: "humidity.fill",
                    color: .teal
                )
                infoRow(
                    label: "GSR",
                    value: String(format: "%.2f µS", reading.gsrUS),
                    icon: "hand.raised.fill",
                    color: .cyan
                )
                infoRow(
                    label: "Contact Quality",
                    value: "\(reading.contactQuality) / 100",
                    icon: "circle.dotted",
                    color: colorForContactQuality(reading.contactQuality)
                )
                infoRow(
                    label: "Last Update",
                    value: reading.timestamp.formatted(date: .omitted, time: .standard),
                    icon: "clock.fill",
                    color: .secondary
                )
            } else {
                ContentUnavailableView(
                    "No Data",
                    systemImage: "waveform.path.ecg.rectangle",
                    description: Text("Connect your device to see live sensor data.")
                )
                .listRowBackground(Color.clear)
            }
        }
    }

    private var actionsSection: some View {
        Section("Actions") {
            Button {
                bleManager.triggerMeasurement()
            } label: {
                Label("Trigger Measurement", systemImage: "play.circle.fill")
            }
            .disabled(!bleManager.isConnected)

            Button(role: .destructive) {
                showForgetAlert = true
            } label: {
                Label("Forget Device", systemImage: "trash.fill")
            }
            .disabled(!bleManager.isConnected)
            .alert("Forget Device?", isPresented: $showForgetAlert) {
                Button("Forget", role: .destructive) {
                    bleManager.disconnect()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will disconnect and forget the paired CortiPod. You can reconnect by scanning again.")
            }
        }
    }

    // MARK: - Helpers

    private func infoRow(label: String, value: String, icon: String, color: Color) -> some View {
        HStack {
            Label(label, systemImage: icon)
                .foregroundStyle(color)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .font(.subheadline)
                .monospacedDigit()
        }
    }

    private var batteryIcon: String {
        switch bleManager.batteryLevel {
        case 75...:  return "battery.100"
        case 50..<75: return "battery.75"
        case 25..<50: return "battery.25"
        case 0..<25:  return "battery.0"
        default:      return "battery.0"
        }
    }

    private var batteryColor: Color {
        switch bleManager.batteryLevel {
        case 50...:  return .green
        case 20..<50: return .orange
        case 0..<20:  return .red
        default:      return .secondary
        }
    }

    private func colorForContactQuality(_ quality: UInt8) -> Color {
        switch quality {
        case 75...:  return .green
        case 40..<75: return .orange
        default:      return .red
        }
    }
}

#Preview {
    DeviceView()
        .environmentObject(BLEManager())
}

import SwiftUI
import Charts

/// Main screen — shows the current calibrated cortisol level, a mini trend
/// chart, and a confidence badge.
struct DashboardView: View {
    @EnvironmentObject private var bleManager: BLEManager
    @EnvironmentObject private var calibrationEngine: CalibrationEngine
    @EnvironmentObject private var readingStore: ReadingStore

    /// Live calibrated reading derived from BLEManager.latestReading
    @State private var currentReading: CalibratedReading?
    @State private var recentHistory: [(Date, Float)] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    cortisolCard
                    confidenceBadge
                    miniChart
                    measureButton
                }
                .padding()
            }
            .navigationTitle("CortiPod")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    connectionIndicator
                }
            }
            .onAppear {
                loadTodaysHistory()
            }
            .onChange(of: bleManager.latestReading) { _, reading in
                guard let reading else { return }
                currentReading = calibrationEngine.process(reading: reading)
                loadTodaysHistory()
            }
        }
    }

    // MARK: - Subviews

    private var cortisolCard: some View {
        VStack(spacing: 8) {
            Text("Cortisol Level")
                .font(.headline)
                .foregroundStyle(.secondary)

            if let reading = currentReading {
                Text(String(format: "%.1f", reading.cortisolNgMl))
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundStyle(colorForLevel(reading.levelCategory))
                    .contentTransition(.numericText())

                Text("ng/mL")
                    .font(.title2)
                    .foregroundStyle(.secondary)

                Text(reading.levelCategory.rawValue)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(colorForLevel(reading.levelCategory))
            } else {
                Text("--")
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
                Text("ng/mL")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text(bleManager.isConnected ? "Waiting for reading…" : "Connect a device")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }

    private var confidenceBadge: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(confidenceColor)

            VStack(alignment: .leading, spacing: 2) {
                Text("Signal Confidence")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                if let reading = currentReading {
                    ProgressView(value: Double(reading.confidence))
                        .tint(confidenceColor)
                    Text(String(format: "%.0f%%", reading.confidence * 100))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                } else {
                    ProgressView(value: 0.0)
                        .tint(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var miniChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Trend")
                .font(.headline)

            if recentHistory.isEmpty {
                ContentUnavailableView(
                    "No Data Yet",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("Readings will appear here once your device sends data.")
                )
                .frame(height: 160)
            } else {
                Chart {
                    ForEach(recentHistory, id: \.0) { date, value in
                        LineMark(
                            x: .value("Time", date),
                            y: .value("Cortisol", value)
                        )
                        .foregroundStyle(.indigo)
                        .interpolationMethod(.catmullRom)

                        AreaMark(
                            x: .value("Time", date),
                            y: .value("Cortisol", value)
                        )
                        .foregroundStyle(.indigo.opacity(0.15))
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartYAxisLabel("ng/mL")
                .frame(height: 160)
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var measureButton: some View {
        Button {
            bleManager.triggerMeasurement()
        } label: {
            Label("Take Reading", systemImage: "waveform.path.ecg")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .tint(.indigo)
        .disabled(!bleManager.isConnected)
    }

    private var connectionIndicator: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(bleManager.isConnected ? Color.green : Color.red)
                .frame(width: 8, height: 8)
            Text(bleManager.isConnected ? "Connected" : "Disconnected")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Helpers

    private func loadTodaysHistory() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let readings = readingStore.fetchReadings(from: startOfDay)
        recentHistory = readings.map { r in
            let calibrated = calibrationEngine.process(reading: r)
            return (r.timestamp, calibrated.cortisolNgMl)
        }
    }

    private var confidenceColor: Color {
        guard let confidence = currentReading?.confidence else { return .secondary }
        switch confidence {
        case 0.8...: return .green
        case 0.5..<0.8: return .orange
        default: return .red
        }
    }

    private func colorForLevel(_ level: CortisolLevel) -> Color {
        switch level {
        case .low:      return .blue
        case .normal:   return .green
        case .elevated: return .orange
        case .high:     return .red
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: SensorReading.self, CalibrationProfile.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let profile = CalibrationProfile(slope: 2.5, intercept: 1.0, baseline: 0.2)
    let store = ReadingStore(modelContext: ModelContext(container))
    let engine = CalibrationEngine(profile: profile)
    return DashboardView()
        .environmentObject(BLEManager())
        .environmentObject(engine)
        .environmentObject(store)
        .modelContainer(container)
}

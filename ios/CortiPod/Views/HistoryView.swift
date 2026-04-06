import SwiftUI
import Charts
import SwiftData

/// Displays historical cortisol trends for selectable time ranges.
struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SensorReading.timestamp, order: .forward)
    private var allReadings: [SensorReading]

    @EnvironmentObject private var calibrationEngine: CalibrationEngine

    @State private var selectedRange: TimeRange = .day

    enum TimeRange: String, CaseIterable {
        case day  = "24h"
        case week = "7d"
        case month = "30d"

        var lookback: TimeInterval {
            switch self {
            case .day:   return 86_400
            case .week:  return 86_400 * 7
            case .month: return 86_400 * 30
            }
        }
    }

    private var filteredReadings: [SensorReading] {
        let cutoff = Date().addingTimeInterval(-selectedRange.lookback)
        return allReadings.filter { $0.timestamp >= cutoff }
    }

    private var chartData: [(date: Date, ngMl: Float)] {
        filteredReadings.map { reading in
            let calibrated = calibrationEngine.process(reading: reading)
            return (reading.timestamp, calibrated.cortisolNgMl)
        }
    }

    private var averageNgMl: Float? {
        guard !chartData.isEmpty else { return nil }
        return chartData.map(\.ngMl).reduce(0, +) / Float(chartData.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    rangePicker
                    summaryCards
                    trendChart
                    readingsList
                }
                .padding()
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Subviews

    private var rangePicker: some View {
        Picker("Time Range", selection: $selectedRange) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
    }

    private var summaryCards: some View {
        HStack(spacing: 12) {
            summaryCard(
                title: "Readings",
                value: "\(chartData.count)",
                icon: "waveform",
                color: .indigo
            )
            summaryCard(
                title: "Average",
                value: averageNgMl.map { String(format: "%.1f ng/mL", $0) } ?? "--",
                icon: "chart.bar.fill",
                color: .teal
            )
        }
    }

    private func summaryCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(color)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private var trendChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cortisol Trend")
                .font(.headline)

            if chartData.isEmpty {
                ContentUnavailableView(
                    "No Data",
                    systemImage: "chart.line.uptrend.xyaxis",
                    description: Text("No readings recorded in the past \(selectedRange.rawValue).")
                )
                .frame(height: 200)
            } else {
                Chart {
                    ForEach(chartData, id: \.date) { item in
                        LineMark(
                            x: .value("Time", item.date),
                            y: .value("Cortisol", item.ngMl)
                        )
                        .foregroundStyle(.indigo)
                        .interpolationMethod(.catmullRom)

                        AreaMark(
                            x: .value("Time", item.date),
                            y: .value("Cortisol", item.ngMl)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.indigo.opacity(0.3), .indigo.opacity(0.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)
                    }

                    if let avg = averageNgMl {
                        RuleMark(y: .value("Average", avg))
                            .foregroundStyle(.orange.opacity(0.7))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [4]))
                            .annotation(position: .trailing) {
                                Text("Avg")
                                    .font(.caption2)
                                    .foregroundStyle(.orange)
                            }
                    }
                }
                .chartYAxisLabel("ng/mL")
                .frame(height: 220)
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var readingsList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Readings")
                .font(.headline)

            ForEach(filteredReadings.suffix(20).reversed()) { reading in
                let calibrated = calibrationEngine.process(reading: reading)
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(reading.timestamp.formatted(date: .omitted, time: .shortened))
                            .font(.subheadline.weight(.medium))
                        Text(reading.timestamp.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(String(format: "%.1f ng/mL", calibrated.cortisolNgMl))
                            .font(.subheadline.weight(.semibold))
                        Text(String(format: "%.0f%% confidence", calibrated.confidence * 100))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
                Divider()
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    let container = try! ModelContainer(
        for: SensorReading.self, CalibrationProfile.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let profile = CalibrationProfile(slope: 2.5, intercept: 1.0, baseline: 0.2)
    let engine = CalibrationEngine(profile: profile)
    return HistoryView()
        .environmentObject(engine)
        .modelContainer(container)
}

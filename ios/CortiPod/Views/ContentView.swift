import SwiftUI

/// Root navigation container. Uses a TabView to surface the four primary
/// sections of the app.
struct ContentView: View {
    @EnvironmentObject private var bleManager: BLEManager
    @EnvironmentObject private var calibrationEngine: CalibrationEngine
    @EnvironmentObject private var readingStore: ReadingStore

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "heart.fill")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "chart.line.uptrend.xyaxis")
                }

            CalibrationView()
                .tabItem {
                    Label("Calibrate", systemImage: "slider.horizontal.3")
                }

            DeviceView()
                .tabItem {
                    Label("Device", systemImage: "sensor.tag.radiowaves.forward.fill")
                }
        }
        .tint(.indigo)
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
    return ContentView()
        .environmentObject(BLEManager())
        .environmentObject(engine)
        .environmentObject(store)
        .modelContainer(container)
}

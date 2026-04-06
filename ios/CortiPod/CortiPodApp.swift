import SwiftUI
import SwiftData

@main
struct CortiPodApp: App {

    // MARK: - Global Services

    @StateObject private var bleManager = BLEManager()
    @StateObject private var readingStore: ReadingStore
    @StateObject private var calibrationEngine: CalibrationEngine

    // MARK: - SwiftData Container

    private let modelContainer: ModelContainer = {
        let schema = Schema([
            SensorReading.self,
            CalibrationProfile.self
        ])
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .none
        )
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create CortiPod model container: \(error)")
        }
    }()

    // MARK: - Init

    init() {
        // Build the shared model context from the container created above.
        // We re-create the container here so the context is available at init time.
        let schema = Schema([SensorReading.self, CalibrationProfile.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .none)
        let container = (try? ModelContainer(for: schema, configurations: [config]))
            ?? (try! ModelContainer(for: schema))
        let context = ModelContext(container)

        let store = ReadingStore(modelContext: context)

        // Load the persisted profile, or fall back to a sensible default.
        let profile = store.latestCalibrationProfile()
            ?? CalibrationProfile(slope: 2.5, intercept: 1.0, baseline: 0.2)

        _readingStore = StateObject(wrappedValue: store)
        _calibrationEngine = StateObject(wrappedValue: CalibrationEngine(profile: profile))
    }

    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bleManager)
                .environmentObject(calibrationEngine)
                .environmentObject(readingStore)
                .onChange(of: bleManager.latestReading) { _, reading in
                    guard let reading else { return }
                    try? readingStore.save(reading: reading)
                }
        }
        .modelContainer(modelContainer)
    }
}

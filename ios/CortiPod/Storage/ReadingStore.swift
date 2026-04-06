import Foundation
import SwiftData

/// Provides a clean persistence interface over SwiftData for sensor readings
/// and calibration profiles.
@MainActor
final class ReadingStore: ObservableObject {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - Save

    /// Persists a new SensorReading to the store.
    func save(reading: SensorReading) throws {
        modelContext.insert(reading)
        try modelContext.save()
    }

    /// Persists a CalibrationProfile to the store.
    func save(profile: CalibrationProfile) throws {
        modelContext.insert(profile)
        try modelContext.save()
    }

    // MARK: - Fetch

    /// Fetches all SensorReadings within the given date range, sorted oldest first.
    ///
    /// - Parameters:
    ///   - from: Start of the range (inclusive)
    ///   - to: End of the range (inclusive), defaults to now
    /// - Returns: Array of matching SensorReadings
    func fetchReadings(from start: Date, to end: Date = Date()) -> [SensorReading] {
        let descriptor = FetchDescriptor<SensorReading>(
            predicate: #Predicate { $0.timestamp >= start && $0.timestamp <= end },
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    /// Fetches the most recent N sensor readings.
    func fetchLatestReadings(limit: Int = 100) -> [SensorReading] {
        var descriptor = FetchDescriptor<SensorReading>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    /// Returns the most recently saved CalibrationProfile, if any.
    func latestCalibrationProfile() -> CalibrationProfile? {
        var descriptor = FetchDescriptor<CalibrationProfile>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return try? modelContext.fetch(descriptor).first
    }

    // MARK: - Aggregation

    /// Computes daily average cortisol raw values (µA) for the past N days.
    ///
    /// Groups readings by calendar day (using the device's local timezone)
    /// and returns one (Date, Float) pair per day that has at least one reading.
    /// The returned Date is the start of the calendar day.
    ///
    /// - Parameter days: Number of days to look back (default 7)
    /// - Returns: Array of (dayStart, averageRawUA) pairs, sorted oldest first
    func dailyAverages(days: Int = 7) -> [(Date, Float)] {
        let calendar = Calendar.current
        let end = Date()
        guard let start = calendar.date(byAdding: .day, value: -days, to: end) else {
            return []
        }

        let readings = fetchReadings(from: start, to: end)

        // Group by start-of-day
        var byDay: [Date: [Float]] = [:]
        for reading in readings {
            let dayStart = calendar.startOfDay(for: reading.timestamp)
            byDay[dayStart, default: []].append(reading.cortisolRawUA)
        }

        return byDay
            .map { (day, values) -> (Date, Float) in
                let average = values.reduce(0, +) / Float(values.count)
                return (day, average)
            }
            .sorted { $0.0 < $1.0 }
    }

    /// Computes daily averages of calibrated cortisol (ng/mL) using a given engine.
    ///
    /// - Parameters:
    ///   - engine: CalibrationEngine to convert raw values
    ///   - days: Number of days to look back
    /// - Returns: Array of (dayStart, averageNgMl) pairs
    func dailyCalibratedAverages(
        using engine: CalibrationEngine,
        days: Int = 7
    ) -> [(Date, Float)] {
        let calendar = Calendar.current
        let end = Date()
        guard let start = calendar.date(byAdding: .day, value: -days, to: end) else {
            return []
        }

        let readings = fetchReadings(from: start, to: end)

        var byDay: [Date: [Float]] = [:]
        for reading in readings {
            let calibrated = engine.process(reading: reading)
            let dayStart = calendar.startOfDay(for: reading.timestamp)
            byDay[dayStart, default: []].append(calibrated.cortisolNgMl)
        }

        return byDay
            .map { (day, values) -> (Date, Float) in
                let average = values.reduce(0, +) / Float(values.count)
                return (day, average)
            }
            .sorted { $0.0 < $1.0 }
    }

    // MARK: - Delete

    /// Removes all SensorReadings older than the specified date.
    func deleteReadings(olderThan cutoff: Date) throws {
        let descriptor = FetchDescriptor<SensorReading>(
            predicate: #Predicate { $0.timestamp < cutoff }
        )
        let old = (try? modelContext.fetch(descriptor)) ?? []
        old.forEach { modelContext.delete($0) }
        try modelContext.save()
    }
}

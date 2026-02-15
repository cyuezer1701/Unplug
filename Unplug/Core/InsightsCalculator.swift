import Foundation

enum InsightsCalculator {

    struct DayValue: Sendable {
        let date: Date
        let value: Double
    }

    struct TriggerCount: Sendable {
        let trigger: Trigger
        let count: Int
    }

    // MARK: - Mood

    static func moodTrend(entries: [MoodEntry], days: Int = 7) -> [DayValue] {
        let calendar = Calendar.current
        let now = Date.now
        var result: [DayValue] = []

        for dayOffset in (0..<days).reversed() {
            guard let day = calendar.date(byAdding: .day, value: -dayOffset, to: now) else { continue }
            let startOfDay = calendar.startOfDay(for: day)
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { continue }

            let dayEntries = entries.filter { entry in
                entry.createdAt >= startOfDay && entry.createdAt < endOfDay
            }

            if !dayEntries.isEmpty {
                let avg = Double(dayEntries.reduce(0) { $0 + $1.moodLevel }) / Double(dayEntries.count)
                result.append(DayValue(date: startOfDay, value: avg))
            }
        }

        return result
    }

    static func averageMood(entries: [MoodEntry]) -> Double {
        guard !entries.isEmpty else { return 0 }
        return Double(entries.reduce(0) { $0 + $1.moodLevel }) / Double(entries.count)
    }

    // MARK: - Triggers

    static func triggerFrequency(sessions: [ScrollSession]) -> [TriggerCount] {
        var counts: [Trigger: Int] = [:]
        for session in sessions {
            if let trigger = session.trigger {
                counts[trigger, default: 0] += 1
            }
        }
        return counts
            .map { TriggerCount(trigger: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }

    // MARK: - Sessions

    static func totalMinutesSaved(sessions: [ScrollSession]) -> Int {
        sessions
            .filter { $0.interventionAccepted }
            .reduce(0) { $0 + $1.durationMinutes }
    }

    static func dailySessionCounts(sessions: [ScrollSession], days: Int = 7) -> [DayValue] {
        let calendar = Calendar.current
        let now = Date.now
        var result: [DayValue] = []

        for dayOffset in (0..<days).reversed() {
            guard let day = calendar.date(byAdding: .day, value: -dayOffset, to: now) else { continue }
            let startOfDay = calendar.startOfDay(for: day)
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { continue }

            let count = sessions.filter { session in
                session.startedAt >= startOfDay && session.startedAt < endOfDay
            }.count

            result.append(DayValue(date: startOfDay, value: Double(count)))
        }

        return result
    }
}

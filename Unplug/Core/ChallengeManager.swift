import Foundation

enum ChallengeManager {

    // MARK: - Preset IDs

    enum PresetID: String, CaseIterable, Sendable {
        case firstSteps
        case mindfulMorning
        case phoneFreeEvening
        case streakBuilder
        case moodTracker
        case triggerMaster
        case hundredMinutes
        case mindfulWeek
    }

    // MARK: - Preset Catalog

    static func presetChallenges(userId: String) -> [Challenge] {
        [
            Challenge(
                id: PresetID.firstSteps.rawValue,
                title: String(localized: "challenge.firstSteps.title"),
                description: String(localized: "challenge.firstSteps.description"),
                durationDays: 3,
                type: .daily
            ),
            Challenge(
                id: PresetID.mindfulMorning.rawValue,
                title: String(localized: "challenge.mindfulMorning.title"),
                description: String(localized: "challenge.mindfulMorning.description"),
                durationDays: 7,
                type: .daily
            ),
            Challenge(
                id: PresetID.phoneFreeEvening.rawValue,
                title: String(localized: "challenge.phoneFreeEvening.title"),
                description: String(localized: "challenge.phoneFreeEvening.description"),
                durationDays: 5,
                type: .daily
            ),
            Challenge(
                id: PresetID.streakBuilder.rawValue,
                title: String(localized: "challenge.streakBuilder.title"),
                description: String(localized: "challenge.streakBuilder.description"),
                durationDays: 7,
                type: .weekly
            ),
            Challenge(
                id: PresetID.moodTracker.rawValue,
                title: String(localized: "challenge.moodTracker.title"),
                description: String(localized: "challenge.moodTracker.description"),
                durationDays: 7,
                type: .daily
            ),
            Challenge(
                id: PresetID.triggerMaster.rawValue,
                title: String(localized: "challenge.triggerMaster.title"),
                description: String(localized: "challenge.triggerMaster.description"),
                durationDays: 7,
                type: .weekly
            ),
            Challenge(
                id: PresetID.hundredMinutes.rawValue,
                title: String(localized: "challenge.hundredMinutes.title"),
                description: String(localized: "challenge.hundredMinutes.description"),
                durationDays: 30,
                type: .custom,
                targetMinutes: 100
            ),
            Challenge(
                id: PresetID.mindfulWeek.rawValue,
                title: String(localized: "challenge.mindfulWeek.title"),
                description: String(localized: "challenge.mindfulWeek.description"),
                durationDays: 7,
                type: .weekly
            ),
        ]
    }

    // MARK: - Progress Calculation

    static func calculateProgress(challenge: Challenge, sessions: [ScrollSession], moods: [MoodEntry]) -> Double {
        guard let startDate = challenge.startDate else { return 0 }
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .day, value: challenge.durationDays, to: startDate) ?? startDate

        let relevantSessions = sessions.filter { $0.startedAt >= startDate && $0.startedAt < endDate }
        let relevantMoods = moods.filter { $0.createdAt >= startDate && $0.createdAt < endDate }

        guard let presetID = PresetID(rawValue: challenge.id ?? "") else {
            return genericProgress(challenge: challenge, sessions: relevantSessions)
        }

        let raw: Double
        switch presetID {
        case .firstSteps:
            raw = firstStepsProgress(sessions: relevantSessions, durationDays: challenge.durationDays)
        case .mindfulMorning:
            raw = mindfulMorningProgress(sessions: relevantSessions, durationDays: challenge.durationDays)
        case .phoneFreeEvening:
            raw = phoneFreeEveningProgress(sessions: relevantSessions, startDate: startDate, durationDays: challenge.durationDays)
        case .streakBuilder:
            raw = streakBuilderProgress(sessions: relevantSessions)
        case .moodTracker:
            raw = moodTrackerProgress(moods: relevantMoods, durationDays: challenge.durationDays)
        case .triggerMaster:
            raw = triggerMasterProgress(sessions: relevantSessions)
        case .hundredMinutes:
            raw = hundredMinutesProgress(sessions: relevantSessions, target: challenge.targetMinutes ?? 100)
        case .mindfulWeek:
            raw = mindfulWeekProgress(sessions: relevantSessions, durationDays: challenge.durationDays)
        }
        return min(raw, 1.0)
    }

    static func isCompleted(challenge: Challenge, sessions: [ScrollSession], moods: [MoodEntry]) -> Bool {
        calculateProgress(challenge: challenge, sessions: sessions, moods: moods) >= 1.0
    }

    // MARK: - Individual Progress Calculations

    /// First Steps: 1 accepted intervention per day for N days
    private static func firstStepsProgress(sessions: [ScrollSession], durationDays: Int) -> Double {
        let daysWithIntervention = uniqueDaysWithAcceptedIntervention(sessions)
        return Double(daysWithIntervention) / Double(durationDays)
    }

    /// Mindful Morning: 1 accepted intervention before 10am each day for N days
    private static func mindfulMorningProgress(sessions: [ScrollSession], durationDays: Int) -> Double {
        let calendar = Calendar.current
        let morningSessions = sessions.filter { session in
            session.interventionAccepted && calendar.component(.hour, from: session.startedAt) < 10
        }
        let uniqueDays = Set(morningSessions.map { calendar.startOfDay(for: $0.startedAt) })
        return Double(uniqueDays.count) / Double(durationDays)
    }

    /// Phone-Free Evening: no sessions after 8pm for N days
    private static func phoneFreeEveningProgress(sessions: [ScrollSession], startDate: Date, durationDays: Int) -> Double {
        let calendar = Calendar.current
        var freeDays = 0
        for dayOffset in 0..<durationDays {
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: startDate) else { continue }
            let startOfDay = calendar.startOfDay(for: day)
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { continue }

            // Only count days that have passed
            guard startOfDay < Date.now else { break }

            let eveningSessions = sessions.filter { session in
                session.startedAt >= startOfDay && session.startedAt < endOfDay
                    && calendar.component(.hour, from: session.startedAt) >= 20
            }
            if eveningSessions.isEmpty { freeDays += 1 }
        }
        return Double(freeDays) / Double(durationDays)
    }

    /// Streak Builder: accumulate 7 consecutive days with interventions
    private static func streakBuilderProgress(sessions: [ScrollSession]) -> Double {
        let calendar = Calendar.current
        let sortedDays = Set(
            sessions
                .filter(\.interventionAccepted)
                .map { calendar.startOfDay(for: $0.startedAt) }
        ).sorted()

        guard !sortedDays.isEmpty else { return 0 }

        var maxStreak = 1
        var currentStreak = 1
        for i in 1..<sortedDays.count {
            let diff = calendar.dateComponents([.day], from: sortedDays[i - 1], to: sortedDays[i]).day ?? 0
            if diff == 1 {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else {
                currentStreak = 1
            }
        }
        return Double(maxStreak) / 7.0
    }

    /// Mood Tracker: log mood each day for N days
    private static func moodTrackerProgress(moods: [MoodEntry], durationDays: Int) -> Double {
        let calendar = Calendar.current
        let uniqueDays = Set(moods.map { calendar.startOfDay(for: $0.createdAt) })
        return Double(uniqueDays.count) / Double(durationDays)
    }

    /// Trigger Master: identify 5 different triggers
    private static func triggerMasterProgress(sessions: [ScrollSession]) -> Double {
        let uniqueTriggers = Set(sessions.compactMap(\.trigger))
        return Double(uniqueTriggers.count) / 5.0
    }

    /// 100 Minutes: save 100+ minutes via accepted interventions
    private static func hundredMinutesProgress(sessions: [ScrollSession], target: Int) -> Double {
        let saved = InsightsCalculator.totalMinutesSaved(sessions: sessions)
        return Double(saved) / Double(target)
    }

    /// Mindful Week: 3+ interventions per day for N days
    private static func mindfulWeekProgress(sessions: [ScrollSession], durationDays: Int) -> Double {
        let calendar = Calendar.current
        let acceptedSessions = sessions.filter(\.interventionAccepted)
        var daysWithThreeOrMore = 0

        let grouped = Dictionary(grouping: acceptedSessions) { calendar.startOfDay(for: $0.startedAt) }
        for (_, daySessions) in grouped where daySessions.count >= 3 {
            daysWithThreeOrMore += 1
        }
        return Double(daysWithThreeOrMore) / Double(durationDays)
    }

    // MARK: - Helpers

    private static func uniqueDaysWithAcceptedIntervention(_ sessions: [ScrollSession]) -> Int {
        let calendar = Calendar.current
        let accepted = sessions.filter(\.interventionAccepted)
        return Set(accepted.map { calendar.startOfDay(for: $0.startedAt) }).count
    }

    private static func genericProgress(challenge: Challenge, sessions: [ScrollSession]) -> Double {
        guard challenge.durationDays > 0 else { return 0 }
        let daysWithActivity = uniqueDaysWithAcceptedIntervention(sessions)
        return min(Double(daysWithActivity) / Double(challenge.durationDays), 1.0)
    }
}

import Foundation

enum AchievementChecker {

    // MARK: - Individual Checks

    static func isUnlocked(_ type: AchievementType, sessions: [ScrollSession], streakCount: Int, userTriggers: [Trigger], hasBuddy: Bool) -> Bool {
        switch type {
        case .firstDay:
            return !sessions.isEmpty
        case .threeDayStreak:
            return streakCount >= 3
        case .sevenDayStreak:
            return streakCount >= 7
        case .thirtyDayStreak:
            return streakCount >= 30
        case .firstIntervention:
            return sessions.contains { $0.interventionAccepted }
        case .hundredMinutesSaved:
            return InsightsCalculator.totalMinutesSaved(sessions: sessions) >= 100
        case .allTriggersIdentified:
            let loggedTriggers = Set(sessions.compactMap(\.trigger))
            return loggedTriggers.count >= Trigger.allCases.count
        case .firstBuddy:
            return hasBuddy
        }
    }

    // MARK: - Check All (returns only NEW unlocked types)

    static func checkAll(
        sessions: [ScrollSession],
        streakCount: Int,
        userTriggers: [Trigger],
        existingTypes: Set<AchievementType>,
        hasBuddy: Bool
    ) -> [AchievementType] {
        AchievementType.allCases.filter { type in
            !existingTypes.contains(type)
                && isUnlocked(type, sessions: sessions, streakCount: streakCount, userTriggers: userTriggers, hasBuddy: hasBuddy)
        }
    }

    // MARK: - Factory

    static func createAchievement(type: AchievementType, userId: String) -> Achievement {
        let (title, description) = metadata(for: type)
        return Achievement(
            userId: userId,
            type: type,
            title: title,
            description: description,
            unlockedAt: .now
        )
    }

    private static func metadata(for type: AchievementType) -> (title: String, description: String) {
        switch type {
        case .firstDay:
            return (
                String(localized: "achievement.firstDay.title"),
                String(localized: "achievement.firstDay.description")
            )
        case .threeDayStreak:
            return (
                String(localized: "achievement.threeDayStreak.title"),
                String(localized: "achievement.threeDayStreak.description")
            )
        case .sevenDayStreak:
            return (
                String(localized: "achievement.sevenDayStreak.title"),
                String(localized: "achievement.sevenDayStreak.description")
            )
        case .thirtyDayStreak:
            return (
                String(localized: "achievement.thirtyDayStreak.title"),
                String(localized: "achievement.thirtyDayStreak.description")
            )
        case .firstIntervention:
            return (
                String(localized: "achievement.firstIntervention.title"),
                String(localized: "achievement.firstIntervention.description")
            )
        case .hundredMinutesSaved:
            return (
                String(localized: "achievement.hundredMinutesSaved.title"),
                String(localized: "achievement.hundredMinutesSaved.description")
            )
        case .allTriggersIdentified:
            return (
                String(localized: "achievement.allTriggersIdentified.title"),
                String(localized: "achievement.allTriggersIdentified.description")
            )
        case .firstBuddy:
            return (
                String(localized: "achievement.firstBuddy.title"),
                String(localized: "achievement.firstBuddy.description")
            )
        }
    }
}

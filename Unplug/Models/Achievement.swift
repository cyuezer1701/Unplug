import Foundation

enum AchievementType: String, Codable, CaseIterable, Sendable {
    case firstDay
    case threeDayStreak
    case sevenDayStreak
    case thirtyDayStreak
    case firstIntervention
    case hundredMinutesSaved
    case firstBuddy
    case allTriggersIdentified
}

struct Achievement: Codable, Identifiable, Sendable {
    var id: String?
    var userId: String
    var type: AchievementType
    var title: String
    var description: String
    var unlockedAt: Date?

    var isUnlocked: Bool {
        unlockedAt != nil
    }

    var iconName: String {
        switch type {
        case .firstDay: return "star.fill"
        case .threeDayStreak: return "flame.fill"
        case .sevenDayStreak: return "flame.circle.fill"
        case .thirtyDayStreak: return "trophy.fill"
        case .firstIntervention: return "hand.raised.fill"
        case .hundredMinutesSaved: return "clock.badge.checkmark"
        case .firstBuddy: return "person.2.fill"
        case .allTriggersIdentified: return "brain.head.profile"
        }
    }

    init(
        id: String? = nil,
        userId: String,
        type: AchievementType,
        title: String,
        description: String,
        unlockedAt: Date? = nil
    ) {
        self.id = id
        self.userId = userId
        self.type = type
        self.title = title
        self.description = description
        self.unlockedAt = unlockedAt
    }
}

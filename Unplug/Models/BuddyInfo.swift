import Foundation

struct BuddyInfo: Codable, Identifiable, Sendable {
    var id: String?
    var userId: String
    var displayName: String
    var streakCount: Int
    var lastActiveAt: Date
    var addedAt: Date

    init(
        id: String? = nil,
        userId: String,
        displayName: String = "",
        streakCount: Int = 0,
        lastActiveAt: Date = .now,
        addedAt: Date = .now
    ) {
        self.id = id
        self.userId = userId
        self.displayName = displayName
        self.streakCount = streakCount
        self.lastActiveAt = lastActiveAt
        self.addedAt = addedAt
    }
}

struct BuddyProgress: Codable, Sendable {
    var todaySessionCount: Int
    var currentStreak: Int
    var latestMoodLevel: Int?
    var totalMinutesSaved: Int

    init(
        todaySessionCount: Int = 0,
        currentStreak: Int = 0,
        latestMoodLevel: Int? = nil,
        totalMinutesSaved: Int = 0
    ) {
        self.todaySessionCount = todaySessionCount
        self.currentStreak = currentStreak
        self.latestMoodLevel = latestMoodLevel
        self.totalMinutesSaved = totalMinutesSaved
    }
}

struct InviteCode: Codable, Sendable {
    var code: String
    var userId: String
    var createdAt: Date
    var isUsed: Bool

    init(
        code: String,
        userId: String,
        createdAt: Date = .now,
        isUsed: Bool = false
    ) {
        self.code = code
        self.userId = userId
        self.createdAt = createdAt
        self.isUsed = isUsed
    }
}

import FirebaseFirestore
import Foundation

enum StreakType: String, Codable, Sendable {
    case dailyGoal
    case appFree
    case mindfulMinutes
    case checkIn
}

struct Streak: Codable, Identifiable, Sendable {
    @DocumentID var id: String?
    var userId: String
    var type: StreakType
    var currentCount: Int
    var longestCount: Int
    var lastDate: Date
    var startDate: Date

    var isActiveToday: Bool {
        Calendar.current.isDateInToday(lastDate)
    }

    init(
        id: String? = nil,
        userId: String,
        type: StreakType = .dailyGoal,
        currentCount: Int = 0,
        longestCount: Int = 0,
        lastDate: Date = .now,
        startDate: Date = .now
    ) {
        self.id = id
        self.userId = userId
        self.type = type
        self.currentCount = currentCount
        self.longestCount = longestCount
        self.lastDate = lastDate
        self.startDate = startDate
    }
}

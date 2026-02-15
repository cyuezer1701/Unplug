import Foundation

enum ChallengeType: String, Codable, Sendable {
    case daily
    case weekly
    case custom
}

struct Challenge: Codable, Identifiable, Sendable {
    var id: String?
    var title: String
    var description: String
    var durationDays: Int
    var type: ChallengeType
    var targetMinutes: Int?
    var isActive: Bool
    var startDate: Date?
    var completedDate: Date?
    var progress: Double

    init(
        id: String? = nil,
        title: String,
        description: String,
        durationDays: Int = 7,
        type: ChallengeType = .weekly,
        targetMinutes: Int? = nil,
        isActive: Bool = false,
        startDate: Date? = nil,
        completedDate: Date? = nil,
        progress: Double = 0.0
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.durationDays = durationDays
        self.type = type
        self.targetMinutes = targetMinutes
        self.isActive = isActive
        self.startDate = startDate
        self.completedDate = completedDate
        self.progress = progress
    }
}

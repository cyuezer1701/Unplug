import FirebaseFirestore
import Foundation

struct MoodEntry: Codable, Identifiable, Sendable {
    @DocumentID var id: String?
    var userId: String
    var moodLevel: Int
    var notes: String?
    var triggers: [Trigger]?
    var screenTimeMinutes: Int?
    var createdAt: Date

    var moodEmoji: String {
        switch moodLevel {
        case 1: return "😢"
        case 2: return "😕"
        case 3: return "😐"
        case 4: return "😊"
        case 5: return "😄"
        default: return "😐"
        }
    }

    init(
        id: String? = nil,
        userId: String,
        moodLevel: Int = 3,
        notes: String? = nil,
        triggers: [Trigger]? = nil,
        screenTimeMinutes: Int? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.userId = userId
        self.moodLevel = moodLevel
        self.notes = notes
        self.triggers = triggers
        self.screenTimeMinutes = screenTimeMinutes
        self.createdAt = createdAt
    }
}

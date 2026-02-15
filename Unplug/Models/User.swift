import FirebaseFirestore
import Foundation

struct UnplugUser: Codable, Identifiable, Sendable {
    @DocumentID var id: String?
    var email: String?
    var displayName: String?
    var triggers: [Trigger]
    var goals: [String]
    var dailyCheckInTime: Date?
    var screenTimePermissionGranted: Bool
    var notificationsEnabled: Bool
    var onboardingCompleted: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        id: String? = nil,
        email: String? = nil,
        displayName: String? = nil,
        triggers: [Trigger] = [],
        goals: [String] = [],
        dailyCheckInTime: Date? = nil,
        screenTimePermissionGranted: Bool = false,
        notificationsEnabled: Bool = false,
        onboardingCompleted: Bool = false,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.triggers = triggers
        self.goals = goals
        self.dailyCheckInTime = dailyCheckInTime
        self.screenTimePermissionGranted = screenTimePermissionGranted
        self.notificationsEnabled = notificationsEnabled
        self.onboardingCompleted = onboardingCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

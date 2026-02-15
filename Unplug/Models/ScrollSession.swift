import Foundation

struct ScrollSession: Codable, Identifiable, Sendable {
    var id: String?
    var userId: String
    var appBundleId: String?
    var appName: String?
    var duration: TimeInterval
    var trigger: Trigger?
    var interventionShown: Bool
    var interventionAccepted: Bool
    var startedAt: Date
    var endedAt: Date?

    var durationMinutes: Int {
        Int(duration / 60)
    }

    init(
        id: String? = nil,
        userId: String,
        appBundleId: String? = nil,
        appName: String? = nil,
        duration: TimeInterval = 0,
        trigger: Trigger? = nil,
        interventionShown: Bool = false,
        interventionAccepted: Bool = false,
        startedAt: Date = .now,
        endedAt: Date? = nil
    ) {
        self.id = id
        self.userId = userId
        self.appBundleId = appBundleId
        self.appName = appName
        self.duration = duration
        self.trigger = trigger
        self.interventionShown = interventionShown
        self.interventionAccepted = interventionAccepted
        self.startedAt = startedAt
        self.endedAt = endedAt
    }
}

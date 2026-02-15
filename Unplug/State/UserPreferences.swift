import Foundation

final class UserPreferences: @unchecked Sendable {
    static let shared = UserPreferences()

    private nonisolated(unsafe) let defaults: UserDefaults
    private static let suiteName = "group.io.unplug.app"

    private init() {
        self.defaults = UserDefaults(suiteName: UserPreferences.suiteName) ?? .standard
    }

    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: "hasCompletedOnboarding") }
        set { defaults.set(newValue, forKey: "hasCompletedOnboarding") }
    }

    var userId: String? {
        get { defaults.string(forKey: "userId") }
        set { defaults.set(newValue, forKey: "userId") }
    }

    var dailyScrollLimitMinutes: Int {
        get {
            let value = defaults.integer(forKey: "dailyScrollLimitMinutes")
            return value > 0 ? value : 60
        }
        set { defaults.set(newValue, forKey: "dailyScrollLimitMinutes") }
    }

    // MARK: - Widget Data

    var widgetStreakCount: Int {
        get { defaults.integer(forKey: "widgetStreakCount") }
        set { defaults.set(newValue, forKey: "widgetStreakCount") }
    }

    var widgetTodaySessionCount: Int {
        get { defaults.integer(forKey: "widgetTodaySessionCount") }
        set { defaults.set(newValue, forKey: "widgetTodaySessionCount") }
    }

    var widgetMinutesSaved: Int {
        get { defaults.integer(forKey: "widgetMinutesSaved") }
        set { defaults.set(newValue, forKey: "widgetMinutesSaved") }
    }

    var widgetLatestMoodEmoji: String {
        get { defaults.string(forKey: "widgetLatestMoodEmoji") ?? "" }
        set { defaults.set(newValue, forKey: "widgetLatestMoodEmoji") }
    }

    var widgetLastUpdated: Date {
        get { defaults.object(forKey: "widgetLastUpdated") as? Date ?? .distantPast }
        set { defaults.set(newValue, forKey: "widgetLastUpdated") }
    }
}

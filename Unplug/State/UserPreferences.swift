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
}

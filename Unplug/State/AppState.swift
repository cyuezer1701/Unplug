import SwiftUI

@Observable
final class AppState {
    // MARK: - Auth

    var currentUser: UnplugUser?
    var isAuthenticated: Bool = false
    var isLoading: Bool = true

    // MARK: - Onboarding

    var hasCompletedOnboarding: Bool {
        currentUser?.onboardingCompleted ?? false
    }

    // MARK: - Session Data

    var todaySessions: [ScrollSession] = []
    var currentStreak: Streak?
    var recentMoodEntries: [MoodEntry] = []
    var activeChallenges: [Challenge] = []
    var achievements: [Achievement] = []

    // MARK: - UI State

    var selectedTab: AppTab = .home
    var showingError: Bool = false
    var errorMessage: String?

    func setError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}

enum AppTab: String, CaseIterable, Sendable {
    case home
    case insights
    case social
    case settings

    var title: String {
        switch self {
        case .home: return String(localized: "tab.home")
        case .insights: return String(localized: "tab.insights")
        case .social: return String(localized: "tab.social")
        case .settings: return String(localized: "tab.settings")
        }
    }

    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .insights: return "chart.bar.fill"
        case .social: return "person.2.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

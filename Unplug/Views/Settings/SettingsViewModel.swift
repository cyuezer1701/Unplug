import SwiftUI

@Observable
final class SettingsViewModel {
    var scrollLimitMinutes: Int = UserPreferences.shared.dailyScrollLimitMinutes
    var showingResetConfirmation: Bool = false
    var showingSignOutConfirmation: Bool = false
    var isUpdating: Bool = false

    func updateTriggers(_ triggers: [Trigger], appState: AppState) async throws {
        guard var user = appState.currentUser else { return }
        user.triggers = triggers
        user.updatedAt = .now
        appState.currentUser = user
        let firestoreService = FirestoreService()
        try await firestoreService.updateUser(user)
    }

    func updateGoals(_ goals: [String], appState: AppState) async throws {
        guard var user = appState.currentUser else { return }
        user.goals = goals
        user.updatedAt = .now
        appState.currentUser = user
        let firestoreService = FirestoreService()
        try await firestoreService.updateUser(user)
    }

    func updateScrollLimit(_ minutes: Int) {
        scrollLimitMinutes = minutes
        UserPreferences.shared.dailyScrollLimitMinutes = minutes
    }

    func signOut(authService: AuthService, appState: AppState) throws {
        try authService.signOut()
        appState.currentUser = nil
        appState.isAuthenticated = false
        appState.todaySessions = []
        appState.currentStreak = nil
        appState.recentMoodEntries = []
    }

    func resetApp(authService: AuthService, appState: AppState) async throws {
        try signOut(authService: authService, appState: appState)
        UserPreferences.shared.hasCompletedOnboarding = false
        UserPreferences.shared.userId = nil
        UserPreferences.shared.dailyScrollLimitMinutes = 60
    }
}

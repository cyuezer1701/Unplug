import Foundation

@Observable
final class HomeViewModel {
    var isLoading: Bool = true
    private(set) var todaySessionCount: Int = 0
    private(set) var todayScreenTimeMinutes: Int = 0
    private(set) var lastMood: MoodEntry?

    var streakCount: Int {
        appState?.currentStreak?.currentCount ?? 0
    }

    var goalProgress: Double {
        let limit = Double(UserPreferences.shared.dailyScrollLimitMinutes)
        guard limit > 0 else { return 0 }
        let used = Double(todayScreenTimeMinutes)
        let saved = max(0, limit - used)
        return min(saved / limit, 1.0)
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 5..<12: return String(localized: "greeting.morning")
        case 12..<17: return String(localized: "greeting.afternoon")
        case 17..<21: return String(localized: "greeting.evening")
        default: return String(localized: "greeting.night")
        }
    }

    private weak var appState: AppState?

    func loadDashboardData(userId: String, firestoreService: FirestoreService, appState: AppState) async {
        self.appState = appState
        isLoading = true

        async let sessionsTask = firestoreService.getTodaySessions(userId: userId)
        async let streakTask = firestoreService.getStreak(userId: userId, type: .checkIn)
        async let moodsTask = firestoreService.getRecentMoods(userId: userId, limit: 1)

        do {
            let sessions = try await sessionsTask
            let streak = try await streakTask
            let moods = try await moodsTask

            appState.todaySessions = sessions
            appState.currentStreak = streak

            todaySessionCount = sessions.count
            todayScreenTimeMinutes = sessions.reduce(0) { $0 + $1.durationMinutes }
            lastMood = moods.first
        } catch {
            // Offline fallback — keep existing state
        }

        isLoading = false
    }

    func logMood(userId: String, moodLevel: Int, firestoreService: FirestoreService, appState: AppState) async throws {
        let entry = MoodEntry(
            userId: userId,
            moodLevel: moodLevel,
            createdAt: .now
        )
        try await firestoreService.saveMoodEntry(entry)
        appState.recentMoodEntries.insert(entry, at: 0)
        lastMood = entry
    }
}

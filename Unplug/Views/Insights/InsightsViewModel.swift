import Foundation

@Observable
final class InsightsViewModel {
    var isLoading = true
    var moodTrend: [InsightsCalculator.DayValue] = []
    var triggerFrequency: [InsightsCalculator.TriggerCount] = []
    var totalMinutesSaved: Int = 0
    var weeklySessionCount: Int = 0
    var averageMood: Double = 0

    var hasData: Bool {
        !moodTrend.isEmpty || !triggerFrequency.isEmpty || weeklySessionCount > 0
    }

    func loadInsights(userId: String, firestoreService: FirestoreService) async {
        isLoading = true
        let calendar = Calendar.current
        let now = Date.now
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) else {
            isLoading = false
            return
        }

        do {
            async let moodsTask = firestoreService.getMoods(userId: userId, from: weekAgo, to: now)
            async let sessionsTask = firestoreService.getSessions(userId: userId, from: weekAgo, to: now)

            let moods = try await moodsTask
            let sessions = try await sessionsTask

            moodTrend = InsightsCalculator.moodTrend(entries: moods, days: 7)
            triggerFrequency = InsightsCalculator.triggerFrequency(sessions: sessions)
            totalMinutesSaved = InsightsCalculator.totalMinutesSaved(sessions: sessions)
            weeklySessionCount = sessions.count
            averageMood = InsightsCalculator.averageMood(entries: moods)
        } catch {
            // Offline fallback
        }

        isLoading = false
    }
}

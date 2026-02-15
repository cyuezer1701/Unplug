import Foundation
import Testing
@testable import Unplug

@Suite("InsightsCalculator Tests")
struct InsightsCalculatorTests {

    // MARK: - Mood Trend

    @Test func moodTrendReturnsEntriesGroupedByDay() {
        let today = Calendar.current.startOfDay(for: .now)
        let entries = [
            MoodEntry(userId: "u1", moodLevel: 3, createdAt: today.addingTimeInterval(3600)),
            MoodEntry(userId: "u1", moodLevel: 5, createdAt: today.addingTimeInterval(7200)),
        ]
        let trend = InsightsCalculator.moodTrend(entries: entries, days: 1)
        #expect(trend.count == 1)
        #expect(trend.first?.value == 4.0) // average of 3 and 5
    }

    @Test func moodTrendSkipsDaysWithNoEntries() {
        let entries: [MoodEntry] = []
        let trend = InsightsCalculator.moodTrend(entries: entries, days: 7)
        #expect(trend.isEmpty)
    }

    @Test func moodTrendHandlesMultipleDays() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: today) else { return }

        let entries = [
            MoodEntry(userId: "u1", moodLevel: 2, createdAt: yesterday.addingTimeInterval(3600)),
            MoodEntry(userId: "u1", moodLevel: 4, createdAt: today.addingTimeInterval(3600)),
        ]
        let trend = InsightsCalculator.moodTrend(entries: entries, days: 2)
        #expect(trend.count == 2)
    }

    // MARK: - Average Mood

    @Test func averageMoodCalculatesCorrectly() {
        let entries = [
            MoodEntry(userId: "u1", moodLevel: 2),
            MoodEntry(userId: "u1", moodLevel: 4),
            MoodEntry(userId: "u1", moodLevel: 3),
        ]
        #expect(InsightsCalculator.averageMood(entries: entries) == 3.0)
    }

    @Test func averageMoodReturnsZeroForEmpty() {
        #expect(InsightsCalculator.averageMood(entries: []) == 0)
    }

    // MARK: - Trigger Frequency

    @Test func triggerFrequencySortsDescending() {
        let sessions = [
            ScrollSession(userId: "u1", trigger: .boredom, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .stress, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .stress, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .boredom, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .boredom, startedAt: .now),
        ]
        let freq = InsightsCalculator.triggerFrequency(sessions: sessions)
        #expect(freq.first?.trigger == .boredom)
        #expect(freq.first?.count == 3)
        #expect(freq[1].trigger == .stress)
        #expect(freq[1].count == 2)
    }

    @Test func triggerFrequencyIgnoresNilTriggers() {
        let sessions = [
            ScrollSession(userId: "u1", trigger: nil, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .boredom, startedAt: .now),
        ]
        let freq = InsightsCalculator.triggerFrequency(sessions: sessions)
        #expect(freq.count == 1)
    }

    @Test func triggerFrequencyReturnsEmptyForNoSessions() {
        #expect(InsightsCalculator.triggerFrequency(sessions: []).isEmpty)
    }

    // MARK: - Minutes Saved

    @Test func totalMinutesSavedOnlyCountsAccepted() {
        let sessions = [
            ScrollSession(userId: "u1", duration: 600, interventionAccepted: true, startedAt: .now),
            ScrollSession(userId: "u1", duration: 300, interventionAccepted: false, startedAt: .now),
            ScrollSession(userId: "u1", duration: 900, interventionAccepted: true, startedAt: .now),
        ]
        #expect(InsightsCalculator.totalMinutesSaved(sessions: sessions) == 25) // 10 + 15
    }

    @Test func totalMinutesSavedReturnsZeroForEmpty() {
        #expect(InsightsCalculator.totalMinutesSaved(sessions: []) == 0)
    }

    // MARK: - Daily Session Counts

    @Test func dailySessionCountsGroupsByDay() {
        let today = Calendar.current.startOfDay(for: .now)
        let sessions = [
            ScrollSession(userId: "u1", startedAt: today.addingTimeInterval(3600)),
            ScrollSession(userId: "u1", startedAt: today.addingTimeInterval(7200)),
        ]
        let counts = InsightsCalculator.dailySessionCounts(sessions: sessions, days: 1)
        #expect(counts.count == 1)
        #expect(counts.first?.value == 2.0)
    }

    @Test func dailySessionCountsReturnsZeroForDaysWithNoSessions() {
        let counts = InsightsCalculator.dailySessionCounts(sessions: [], days: 3)
        #expect(counts.count == 3)
        #expect(counts.allSatisfy { $0.value == 0 })
    }
}

import Foundation
import Testing
@testable import Unplug

@Suite("ChallengeManager Tests")
struct ChallengeManagerTests {

    // MARK: - Test Helpers

    private func makeSession(
        at date: Date = .now,
        accepted: Bool = true,
        durationMinutes: Int = 15,
        trigger: Trigger = .boredom
    ) -> ScrollSession {
        ScrollSession(
            userId: "test",
            duration: TimeInterval(durationMinutes * 60),
            trigger: trigger,
            interventionShown: true,
            interventionAccepted: accepted,
            startedAt: date
        )
    }

    private func makeMood(at date: Date = .now) -> MoodEntry {
        MoodEntry(userId: "test", moodLevel: 4, createdAt: date)
    }

    private func makeChallenge(presetID: ChallengeManager.PresetID, startDate: Date = .now) -> Challenge {
        var challenge = ChallengeManager.presetChallenges(userId: "test")
            .first { $0.id == presetID.rawValue }!
        challenge.isActive = true
        challenge.startDate = startDate
        return challenge
    }

    // MARK: - Preset Catalog

    @Test func presetChallengesReturnsAtLeastEight() {
        let challenges = ChallengeManager.presetChallenges(userId: "test")
        #expect(challenges.count >= 8)
    }

    @Test func allPresetsHaveValidFields() {
        for challenge in ChallengeManager.presetChallenges(userId: "test") {
            #expect(!challenge.title.isEmpty, "Title empty for \(challenge.id ?? "unknown")")
            #expect(!challenge.description.isEmpty, "Description empty for \(challenge.id ?? "unknown")")
            #expect(challenge.durationDays > 0, "Duration must be > 0 for \(challenge.id ?? "unknown")")
        }
    }

    @Test func allPresetIDsAreRepresented() {
        let challenges = ChallengeManager.presetChallenges(userId: "test")
        let ids = Set(challenges.compactMap(\.id))
        for presetID in ChallengeManager.PresetID.allCases {
            #expect(ids.contains(presetID.rawValue), "Missing preset: \(presetID)")
        }
    }

    // MARK: - Progress Calculation

    @Test func progressIsZeroWithNoSessions() {
        let challenge = makeChallenge(presetID: .firstSteps)
        let progress = ChallengeManager.calculateProgress(challenge: challenge, sessions: [], moods: [])
        #expect(progress == 0.0)
    }

    @Test func progressIsZeroWithNoStartDate() {
        var challenge = ChallengeManager.presetChallenges(userId: "test").first!
        challenge.startDate = nil
        let progress = ChallengeManager.calculateProgress(challenge: challenge, sessions: [makeSession()], moods: [])
        #expect(progress == 0.0)
    }

    @Test func progressNeverExceedsOne() {
        let startDate = Calendar.current.date(byAdding: .day, value: -10, to: .now)!
        let challenge = makeChallenge(presetID: .firstSteps, startDate: startDate)

        // Create many sessions across many days
        var sessions: [ScrollSession] = []
        for dayOffset in 0..<10 {
            let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: startDate)!
            sessions.append(makeSession(at: date))
        }

        let progress = ChallengeManager.calculateProgress(challenge: challenge, sessions: sessions, moods: [])
        #expect(progress <= 1.0)
    }

    // MARK: - First Steps Progress

    @Test func firstStepsProgressWithOneDayOfThree() {
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        let challenge = makeChallenge(presetID: .firstSteps, startDate: startDate)

        let sessions = [makeSession(at: startDate)]
        let progress = ChallengeManager.calculateProgress(challenge: challenge, sessions: sessions, moods: [])
        #expect(progress > 0.0 && progress < 1.0)
    }

    // MARK: - Mood Tracker Progress

    @Test func moodTrackerProgressCountsUniqueDays() {
        let startDate = Calendar.current.date(byAdding: .day, value: -3, to: .now)!
        let challenge = makeChallenge(presetID: .moodTracker, startDate: startDate)

        let day1 = Calendar.current.date(byAdding: .day, value: 0, to: startDate)!
        let day2 = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!

        let moods = [makeMood(at: day1), makeMood(at: day2)]
        let progress = ChallengeManager.calculateProgress(challenge: challenge, sessions: [], moods: moods)
        #expect(progress > 0.0)
    }

    // MARK: - Trigger Master Progress

    @Test func triggerMasterProgressCountsUniqueTriggers() {
        let startDate = Calendar.current.date(byAdding: .day, value: -3, to: .now)!
        let challenge = makeChallenge(presetID: .triggerMaster, startDate: startDate)

        let sessions = [
            makeSession(at: startDate, trigger: .boredom),
            makeSession(at: startDate, trigger: .stress),
            makeSession(at: startDate, trigger: .anxiety),
        ]
        let progress = ChallengeManager.calculateProgress(challenge: challenge, sessions: sessions, moods: [])
        #expect(progress > 0.0) // 3/5 = 0.6
    }

    // MARK: - Hundred Minutes Progress

    @Test func hundredMinutesProgressBasedOnSavedMinutes() {
        let startDate = Calendar.current.date(byAdding: .day, value: -5, to: .now)!
        let challenge = makeChallenge(presetID: .hundredMinutes, startDate: startDate)

        let sessions = (0..<5).map { _ in makeSession(at: startDate, durationMinutes: 20) }
        let progress = ChallengeManager.calculateProgress(challenge: challenge, sessions: sessions, moods: [])
        #expect(progress == 1.0) // 5 * 20 = 100
    }

    // MARK: - isCompleted

    @Test func isCompletedTrueWhenProgressIsOne() {
        let startDate = Calendar.current.date(byAdding: .day, value: -5, to: .now)!
        let challenge = makeChallenge(presetID: .hundredMinutes, startDate: startDate)

        let sessions = (0..<7).map { _ in makeSession(at: startDate, durationMinutes: 20) }
        #expect(ChallengeManager.isCompleted(challenge: challenge, sessions: sessions, moods: []))
    }

    @Test func isCompletedFalseWhenProgressBelowOne() {
        let challenge = makeChallenge(presetID: .firstSteps)
        #expect(!ChallengeManager.isCompleted(challenge: challenge, sessions: [], moods: []))
    }

    // MARK: - Only Relevant Sessions Counted

    @Test func onlySessionsWithinChallengePeriodAreCounted() {
        let startDate = Calendar.current.date(byAdding: .day, value: -2, to: .now)!
        let challenge = makeChallenge(presetID: .firstSteps, startDate: startDate)

        let beforeStart = Calendar.current.date(byAdding: .day, value: -5, to: .now)!
        let withinPeriod = Calendar.current.date(byAdding: .day, value: -1, to: .now)!

        let sessions = [
            makeSession(at: beforeStart), // outside period
            makeSession(at: withinPeriod), // inside period
        ]

        let progress = ChallengeManager.calculateProgress(challenge: challenge, sessions: sessions, moods: [])
        // Should only count 1 day (withinPeriod), not 2
        let expectedMax = 1.0 / Double(challenge.durationDays)
        #expect(progress <= expectedMax + 0.01)
    }
}

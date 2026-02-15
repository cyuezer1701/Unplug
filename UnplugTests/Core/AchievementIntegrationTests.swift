import Foundation
import Testing
@testable import Unplug

@Suite("Achievement & Challenge Integration Tests")
struct AchievementIntegrationTests {

    // MARK: - Test Helpers

    private func makeSession(
        at date: Date = .now,
        trigger: Trigger? = .boredom,
        accepted: Bool = true,
        durationMinutes: Int = 15
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

    private func makeMood(at date: Date = .now, level: Int = 4) -> MoodEntry {
        MoodEntry(userId: "test", moodLevel: level, createdAt: date)
    }

    private func makeChallenge(presetID: ChallengeManager.PresetID, startDate: Date = .now) -> Challenge {
        var challenge = ChallengeManager.presetChallenges(userId: "test")
            .first { $0.id == presetID.rawValue }!
        challenge.isActive = true
        challenge.startDate = startDate
        return challenge
    }

    // MARK: - Achievement Unlocking After Session

    @Test func achievementUnlockedAfterFirstSession() {
        let sessions = [makeSession()]
        let existing = Set<AchievementType>()

        let newTypes = AchievementChecker.checkAll(
            sessions: sessions,
            streakCount: 0,
            userTriggers: [],
            existingTypes: existing,
            hasBuddy: false
        )

        #expect(newTypes.contains(.firstDay))
        #expect(newTypes.contains(.firstIntervention))
    }

    @Test func multipleAchievementsUnlockedSimultaneously() {
        let sessions = [makeSession(accepted: true, durationMinutes: 15)]

        let newTypes = AchievementChecker.checkAll(
            sessions: sessions,
            streakCount: 7,
            userTriggers: [],
            existingTypes: [],
            hasBuddy: false
        )

        // Should unlock firstDay, firstIntervention, threeDayStreak, sevenDayStreak
        #expect(newTypes.contains(.firstDay))
        #expect(newTypes.contains(.firstIntervention))
        #expect(newTypes.contains(.threeDayStreak))
        #expect(newTypes.contains(.sevenDayStreak))
        #expect(!newTypes.contains(.thirtyDayStreak))
    }

    @Test func achievementCreatedWithCorrectUserId() {
        let achievement = AchievementChecker.createAchievement(type: .firstDay, userId: "user-abc")

        #expect(achievement.userId == "user-abc")
        #expect(achievement.type == .firstDay)
        #expect(achievement.isUnlocked)
        #expect(achievement.unlockedAt != nil)
    }

    // MARK: - Duplicate Achievement Prevention

    @Test func duplicateAchievementsArePrevented() {
        let sessions = [makeSession()]
        let existing: Set<AchievementType> = [.firstDay, .firstIntervention]

        let newTypes = AchievementChecker.checkAll(
            sessions: sessions,
            streakCount: 0,
            userTriggers: [],
            existingTypes: existing,
            hasBuddy: false
        )

        #expect(!newTypes.contains(.firstDay))
        #expect(!newTypes.contains(.firstIntervention))
    }

    @Test func noNewAchievementsWhenAllAlreadyUnlocked() {
        let sessions = Trigger.allCases.map { trigger in
            makeSession(trigger: trigger, accepted: true, durationMinutes: 15)
        }

        let allExisting = Set(AchievementType.allCases)

        let newTypes = AchievementChecker.checkAll(
            sessions: sessions,
            streakCount: 30,
            userTriggers: [],
            existingTypes: allExisting,
            hasBuddy: true
        )

        #expect(newTypes.isEmpty)
    }

    @Test func existingAchievementsNeverReturned() {
        // Even with conditions met, existing types should be excluded
        let sessions = (0..<7).map { _ in makeSession(durationMinutes: 20) }
        let existing: Set<AchievementType> = [.firstDay, .hundredMinutesSaved]

        let newTypes = AchievementChecker.checkAll(
            sessions: sessions,
            streakCount: 3,
            userTriggers: [],
            existingTypes: existing,
            hasBuddy: false
        )

        #expect(!newTypes.contains(.firstDay))
        #expect(!newTypes.contains(.hundredMinutesSaved))
        // But new ones should be present
        #expect(newTypes.contains(.firstIntervention))
        #expect(newTypes.contains(.threeDayStreak))
    }

    // MARK: - Challenge Progress After Session

    @Test func challengeProgressIncreasesAfterSession() {
        let startDate = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        let challenge = makeChallenge(presetID: .firstSteps, startDate: startDate)

        let progressBefore = ChallengeManager.calculateProgress(
            challenge: challenge, sessions: [], moods: []
        )

        let sessions = [makeSession(at: startDate)]
        let progressAfter = ChallengeManager.calculateProgress(
            challenge: challenge, sessions: sessions, moods: []
        )

        #expect(progressAfter > progressBefore)
    }

    @Test func challengeCompletionAtFullProgress() {
        let startDate = Calendar.current.date(byAdding: .day, value: -10, to: .now)!
        let challenge = makeChallenge(presetID: .hundredMinutes, startDate: startDate)

        // Create enough sessions to reach 100 minutes saved
        let sessions = (0..<10).map { _ in makeSession(at: startDate, durationMinutes: 15) }

        let completed = ChallengeManager.isCompleted(
            challenge: challenge, sessions: sessions, moods: []
        )
        let progress = ChallengeManager.calculateProgress(
            challenge: challenge, sessions: sessions, moods: []
        )

        #expect(completed)
        #expect(progress >= 1.0)
        #expect(progress <= 1.0) // capped at 1.0
    }

    @Test func challengeNotCompleteWhenBelowTarget() {
        let startDate = Calendar.current.date(byAdding: .day, value: -2, to: .now)!
        let challenge = makeChallenge(presetID: .hundredMinutes, startDate: startDate)

        let sessions = [makeSession(at: startDate, durationMinutes: 10)]
        let completed = ChallengeManager.isCompleted(
            challenge: challenge, sessions: sessions, moods: []
        )

        #expect(!completed)
    }

    // MARK: - Achievement + Challenge Combined Scenario

    @Test func fullSessionScenarioTriggersAchievementsAndProgress() {
        let startDate = Calendar.current.date(byAdding: .day, value: -5, to: .now)!

        // Simulate user completing sessions over multiple days
        var sessions: [ScrollSession] = []
        for dayOffset in 0..<5 {
            let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: startDate)!
            sessions.append(makeSession(at: date, trigger: .boredom, accepted: true, durationMinutes: 20))
        }

        // Check achievements
        let newAchievements = AchievementChecker.checkAll(
            sessions: sessions,
            streakCount: 5,
            userTriggers: [],
            existingTypes: [],
            hasBuddy: false
        )

        #expect(newAchievements.contains(.firstDay))
        #expect(newAchievements.contains(.firstIntervention))
        #expect(newAchievements.contains(.threeDayStreak))
        #expect(newAchievements.contains(.hundredMinutesSaved)) // 5 * 20 = 100

        // Check challenge progress
        let challenge = makeChallenge(presetID: .firstSteps, startDate: startDate)
        let progress = ChallengeManager.calculateProgress(
            challenge: challenge, sessions: sessions, moods: []
        )

        #expect(progress >= 1.0) // 5 days of interventions for a 3-day challenge
    }

    @Test func incrementalAchievementUnlocking() {
        // Day 1: first session
        let session1 = makeSession(trigger: .boredom)
        var existing = Set<AchievementType>()

        let day1New = AchievementChecker.checkAll(
            sessions: [session1],
            streakCount: 1,
            userTriggers: [],
            existingTypes: existing,
            hasBuddy: false
        )
        #expect(day1New.contains(.firstDay))
        #expect(day1New.contains(.firstIntervention))

        // Record what was unlocked
        existing.formUnion(day1New)

        // Day 3: streak reaches 3
        let session2 = makeSession(trigger: .stress)
        let day3New = AchievementChecker.checkAll(
            sessions: [session1, session2],
            streakCount: 3,
            userTriggers: [],
            existingTypes: existing,
            hasBuddy: false
        )

        #expect(!day3New.contains(.firstDay)) // already unlocked
        #expect(!day3New.contains(.firstIntervention)) // already unlocked
        #expect(day3New.contains(.threeDayStreak)) // newly unlocked

        // Record and continue
        existing.formUnion(day3New)

        // Day 7: streak reaches 7
        let day7New = AchievementChecker.checkAll(
            sessions: [session1, session2],
            streakCount: 7,
            userTriggers: [],
            existingTypes: existing,
            hasBuddy: false
        )

        #expect(!day7New.contains(.threeDayStreak)) // already unlocked
        #expect(day7New.contains(.sevenDayStreak)) // newly unlocked
    }

    // MARK: - Mood Tracker Challenge Integration

    @Test func moodTrackerChallengeProgressWithMoodEntries() {
        let startDate = Calendar.current.date(byAdding: .day, value: -4, to: .now)!
        let challenge = makeChallenge(presetID: .moodTracker, startDate: startDate)

        let moods = (0..<4).map { dayOffset in
            let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: startDate)!
            return makeMood(at: date)
        }

        let progress = ChallengeManager.calculateProgress(
            challenge: challenge, sessions: [], moods: moods
        )

        // 4 days of mood entries out of 7 required
        #expect(progress > 0.5)
        #expect(progress < 1.0)
    }

    // MARK: - Edge Cases

    @Test func emptyStateProducesNoAchievements() {
        let newTypes = AchievementChecker.checkAll(
            sessions: [],
            streakCount: 0,
            userTriggers: [],
            existingTypes: [],
            hasBuddy: false
        )
        #expect(newTypes.isEmpty)
    }

    @Test func emptyStateProducesZeroProgress() {
        let challenge = makeChallenge(presetID: .firstSteps)
        let progress = ChallengeManager.calculateProgress(
            challenge: challenge, sessions: [], moods: []
        )
        #expect(progress == 0.0)
    }

    @Test func buddyAchievementOnlyWithBuddy() {
        let sessions = [makeSession()]

        let withoutBuddy = AchievementChecker.checkAll(
            sessions: sessions,
            streakCount: 0,
            userTriggers: [],
            existingTypes: [],
            hasBuddy: false
        )
        #expect(!withoutBuddy.contains(.firstBuddy))

        let withBuddy = AchievementChecker.checkAll(
            sessions: sessions,
            streakCount: 0,
            userTriggers: [],
            existingTypes: [],
            hasBuddy: true
        )
        #expect(withBuddy.contains(.firstBuddy))
    }

    @Test func allTriggersAchievementRequiresAllEight() {
        // 7 triggers — not enough
        let partialSessions = Trigger.allCases.dropLast().map { trigger in
            makeSession(trigger: trigger)
        }

        let partial = AchievementChecker.checkAll(
            sessions: Array(partialSessions),
            streakCount: 0,
            userTriggers: [],
            existingTypes: [],
            hasBuddy: false
        )
        #expect(!partial.contains(.allTriggersIdentified))

        // All 8 triggers
        let fullSessions = Trigger.allCases.map { trigger in
            makeSession(trigger: trigger)
        }

        let full = AchievementChecker.checkAll(
            sessions: fullSessions,
            streakCount: 0,
            userTriggers: [],
            existingTypes: [],
            hasBuddy: false
        )
        #expect(full.contains(.allTriggersIdentified))
    }
}

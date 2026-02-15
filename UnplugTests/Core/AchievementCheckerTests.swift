import Foundation
import Testing
@testable import Unplug

@Suite("AchievementChecker Tests")
struct AchievementCheckerTests {

    // MARK: - Test Helpers

    private func makeSession(
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
            startedAt: .now
        )
    }

    // MARK: - firstDay

    @Test func firstDayUnlockedWithOneSession() {
        let sessions = [makeSession()]
        let result = AchievementChecker.isUnlocked(.firstDay, sessions: sessions, streakCount: 0, userTriggers: [], hasBuddy: false)
        #expect(result)
    }

    @Test func firstDayNotUnlockedWithNoSessions() {
        let result = AchievementChecker.isUnlocked(.firstDay, sessions: [], streakCount: 0, userTriggers: [], hasBuddy: false)
        #expect(!result)
    }

    // MARK: - Streak Achievements

    @Test func threeDayStreakUnlockedAtThree() {
        let result = AchievementChecker.isUnlocked(.threeDayStreak, sessions: [], streakCount: 3, userTriggers: [], hasBuddy: false)
        #expect(result)
    }

    @Test func threeDayStreakNotUnlockedAtTwo() {
        let result = AchievementChecker.isUnlocked(.threeDayStreak, sessions: [], streakCount: 2, userTriggers: [], hasBuddy: false)
        #expect(!result)
    }

    @Test func sevenDayStreakUnlockedAtSeven() {
        let result = AchievementChecker.isUnlocked(.sevenDayStreak, sessions: [], streakCount: 7, userTriggers: [], hasBuddy: false)
        #expect(result)
    }

    @Test func thirtyDayStreakUnlockedAtThirty() {
        let result = AchievementChecker.isUnlocked(.thirtyDayStreak, sessions: [], streakCount: 30, userTriggers: [], hasBuddy: false)
        #expect(result)
    }

    @Test func thirtyDayStreakNotUnlockedAtTwentyNine() {
        let result = AchievementChecker.isUnlocked(.thirtyDayStreak, sessions: [], streakCount: 29, userTriggers: [], hasBuddy: false)
        #expect(!result)
    }

    // MARK: - firstIntervention

    @Test func firstInterventionUnlockedWithAcceptedSession() {
        let sessions = [makeSession(accepted: true)]
        let result = AchievementChecker.isUnlocked(.firstIntervention, sessions: sessions, streakCount: 0, userTriggers: [], hasBuddy: false)
        #expect(result)
    }

    @Test func firstInterventionNotUnlockedWithRejectedSessions() {
        let sessions = [makeSession(accepted: false)]
        let result = AchievementChecker.isUnlocked(.firstIntervention, sessions: sessions, streakCount: 0, userTriggers: [], hasBuddy: false)
        #expect(!result)
    }

    // MARK: - hundredMinutesSaved

    @Test func hundredMinutesSavedUnlockedAtHundred() {
        let sessions = (0..<7).map { _ in makeSession(accepted: true, durationMinutes: 15) }
        let result = AchievementChecker.isUnlocked(.hundredMinutesSaved, sessions: sessions, streakCount: 0, userTriggers: [], hasBuddy: false)
        #expect(result) // 7 * 15 = 105 >= 100
    }

    @Test func hundredMinutesSavedNotUnlockedBelowHundred() {
        let sessions = (0..<6).map { _ in makeSession(accepted: true, durationMinutes: 15) }
        let result = AchievementChecker.isUnlocked(.hundredMinutesSaved, sessions: sessions, streakCount: 0, userTriggers: [], hasBuddy: false)
        #expect(!result) // 6 * 15 = 90 < 100
    }

    // MARK: - allTriggersIdentified

    @Test func allTriggersIdentifiedWhenAllEightLogged() {
        let sessions = Trigger.allCases.map { trigger in
            makeSession(trigger: trigger)
        }
        let result = AchievementChecker.isUnlocked(.allTriggersIdentified, sessions: sessions, streakCount: 0, userTriggers: [], hasBuddy: false)
        #expect(result)
    }

    @Test func allTriggersNotIdentifiedWhenMissingSome() {
        let sessions = [
            makeSession(trigger: .boredom),
            makeSession(trigger: .stress),
        ]
        let result = AchievementChecker.isUnlocked(.allTriggersIdentified, sessions: sessions, streakCount: 0, userTriggers: [], hasBuddy: false)
        #expect(!result)
    }

    // MARK: - firstBuddy

    @Test func firstBuddyUnlockedWhenHasBuddy() {
        let result = AchievementChecker.isUnlocked(.firstBuddy, sessions: [], streakCount: 0, userTriggers: [], hasBuddy: true)
        #expect(result)
    }

    @Test func firstBuddyNotUnlockedWithoutBuddy() {
        let result = AchievementChecker.isUnlocked(.firstBuddy, sessions: [], streakCount: 0, userTriggers: [], hasBuddy: false)
        #expect(!result)
    }

    // MARK: - checkAll

    @Test func checkAllReturnsOnlyNewAchievements() {
        let sessions = [makeSession(accepted: true)]
        let existing: Set<AchievementType> = [.firstDay]

        let newTypes = AchievementChecker.checkAll(
            sessions: sessions,
            streakCount: 0,
            userTriggers: [],
            existingTypes: existing,
            hasBuddy: false
        )

        #expect(!newTypes.contains(.firstDay)) // already unlocked
        #expect(newTypes.contains(.firstIntervention)) // newly unlocked
    }

    @Test func checkAllReturnsEmptyWhenNoNewAchievements() {
        let newTypes = AchievementChecker.checkAll(
            sessions: [],
            streakCount: 0,
            userTriggers: [],
            existingTypes: [],
            hasBuddy: false
        )

        #expect(newTypes.isEmpty)
    }

    // MARK: - createAchievement

    @Test func createAchievementSetsCorrectFields() {
        let achievement = AchievementChecker.createAchievement(type: .firstDay, userId: "user123")

        #expect(achievement.userId == "user123")
        #expect(achievement.type == .firstDay)
        #expect(!achievement.title.isEmpty)
        #expect(!achievement.description.isEmpty)
        #expect(achievement.unlockedAt != nil)
        #expect(achievement.isUnlocked)
    }

    @Test func createAchievementWorksForAllTypes() {
        for type in AchievementType.allCases {
            let achievement = AchievementChecker.createAchievement(type: type, userId: "test")
            #expect(!achievement.title.isEmpty, "Title should not be empty for \(type)")
            #expect(!achievement.description.isEmpty, "Description should not be empty for \(type)")
        }
    }
}

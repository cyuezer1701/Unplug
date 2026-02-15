import Foundation
import Testing
@testable import Unplug

struct StreakCalculatorTests {
    // MARK: - isStreakActive

    @Test func streakIsActiveWhenLastDateIsToday() {
        let now = Date.now
        #expect(StreakCalculator.isStreakActive(lastDate: now, now: now) == true)
    }

    @Test func streakIsActiveWhenLastDateIsYesterday() {
        let now = Date.now
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        #expect(StreakCalculator.isStreakActive(lastDate: yesterday, now: now) == true)
    }

    @Test func streakIsNotActiveWhenGapExceedsOneDay() {
        let now = Date.now
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: now)!
        #expect(StreakCalculator.isStreakActive(lastDate: twoDaysAgo, now: now) == false)
    }

    @Test func streakIsNotActiveAfterLongGap() {
        let now = Date.now
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        #expect(StreakCalculator.isStreakActive(lastDate: weekAgo, now: now) == false)
    }

    // MARK: - calculateNewCount

    @Test func calculateNewCountIncrementsForConsecutiveDay() {
        let now = Date.now
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let result = StreakCalculator.calculateNewCount(currentCount: 5, lastDate: yesterday, now: now)
        #expect(result == 6)
    }

    @Test func calculateNewCountResetsAfterGap() {
        let now = Date.now
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: now)!
        let result = StreakCalculator.calculateNewCount(currentCount: 10, lastDate: threeDaysAgo, now: now)
        #expect(result == 1)
    }

    @Test func calculateNewCountDoesNotDoubleCountSameDay() {
        let now = Date.now
        let result = StreakCalculator.calculateNewCount(currentCount: 5, lastDate: now, now: now)
        #expect(result == 5)
    }

    @Test func calculateNewCountStartsAtOneAfterLongGap() {
        let now = Date.now
        let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: now)!
        let result = StreakCalculator.calculateNewCount(currentCount: 30, lastDate: monthAgo, now: now)
        #expect(result == 1)
    }

    // MARK: - updateLongest

    @Test func updateLongestReturnsCurrentWhenHigher() {
        #expect(StreakCalculator.updateLongest(current: 10, longest: 5) == 10)
    }

    @Test func updateLongestReturnsLongestWhenHigher() {
        #expect(StreakCalculator.updateLongest(current: 3, longest: 7) == 7)
    }

    @Test func updateLongestReturnsEqualValue() {
        #expect(StreakCalculator.updateLongest(current: 5, longest: 5) == 5)
    }
}

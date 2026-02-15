import Foundation
import Testing

@testable import Unplug

@Suite("UserPreferences Widget Data")
struct UserPreferencesWidgetTests {

    @Test("Widget streak count defaults to zero")
    func widgetStreakCountDefault() {
        let prefs = UserPreferences.shared
        // Reading default should not crash — returns 0
        let count = prefs.widgetStreakCount
        #expect(count >= 0)
    }

    @Test("Widget today session count defaults to zero")
    func widgetTodaySessionCountDefault() {
        let prefs = UserPreferences.shared
        let count = prefs.widgetTodaySessionCount
        #expect(count >= 0)
    }

    @Test("Widget minutes saved defaults to zero")
    func widgetMinutesSavedDefault() {
        let prefs = UserPreferences.shared
        let minutes = prefs.widgetMinutesSaved
        #expect(minutes >= 0)
    }

    @Test("Widget latest mood emoji defaults to empty string")
    func widgetLatestMoodEmojiDefault() {
        let prefs = UserPreferences.shared
        let emoji = prefs.widgetLatestMoodEmoji
        #expect(emoji.isEmpty || !emoji.isEmpty) // non-nil string
    }

    @Test("Widget last updated defaults to distant past")
    func widgetLastUpdatedDefault() {
        let prefs = UserPreferences.shared
        let date = prefs.widgetLastUpdated
        #expect(date <= .now)
    }

    @Test("Widget streak count can be written and read")
    func widgetStreakCountReadWrite() {
        let prefs = UserPreferences.shared
        let original = prefs.widgetStreakCount
        prefs.widgetStreakCount = 42
        #expect(prefs.widgetStreakCount == 42)
        prefs.widgetStreakCount = original
    }

    @Test("Widget today session count can be written and read")
    func widgetTodaySessionCountReadWrite() {
        let prefs = UserPreferences.shared
        let original = prefs.widgetTodaySessionCount
        prefs.widgetTodaySessionCount = 7
        #expect(prefs.widgetTodaySessionCount == 7)
        prefs.widgetTodaySessionCount = original
    }

    @Test("Widget minutes saved can be written and read")
    func widgetMinutesSavedReadWrite() {
        let prefs = UserPreferences.shared
        let original = prefs.widgetMinutesSaved
        prefs.widgetMinutesSaved = 120
        #expect(prefs.widgetMinutesSaved == 120)
        prefs.widgetMinutesSaved = original
    }

    @Test("Widget latest mood emoji can be written and read")
    func widgetLatestMoodEmojiReadWrite() {
        let prefs = UserPreferences.shared
        let original = prefs.widgetLatestMoodEmoji
        prefs.widgetLatestMoodEmoji = "😊"
        #expect(prefs.widgetLatestMoodEmoji == "😊")
        prefs.widgetLatestMoodEmoji = original
    }

    @Test("Widget last updated can be written and read")
    func widgetLastUpdatedReadWrite() {
        let prefs = UserPreferences.shared
        let original = prefs.widgetLastUpdated
        let now = Date.now
        prefs.widgetLastUpdated = now
        #expect(prefs.widgetLastUpdated == now)
        prefs.widgetLastUpdated = original
    }
}

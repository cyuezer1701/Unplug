import Foundation
import Testing
@testable import Unplug

@Suite("TriggerAnalyzer Tests")
struct TriggerAnalyzerTests {

    @Test func suggestedTriggerReturnsInsomniaAtNight() {
        var components = DateComponents()
        components.hour = 2
        let nightTime = Calendar.current.date(from: components) ?? .now
        let trigger = TriggerAnalyzer.suggestedTrigger(timeOfDay: nightTime)
        #expect(trigger == .insomnia)
    }

    @Test func suggestedTriggerReturnsProcrastinationWeekdayMorning() {
        var components = DateComponents()
        components.hour = 10
        let morning = Calendar.current.date(from: components) ?? .now
        let trigger = TriggerAnalyzer.suggestedTrigger(timeOfDay: morning, dayOfWeek: 3)
        #expect(trigger == .procrastination)
    }

    @Test func suggestedTriggerReturnsBoredomAtLunch() {
        var components = DateComponents()
        components.hour = 13
        let lunch = Calendar.current.date(from: components) ?? .now
        let trigger = TriggerAnalyzer.suggestedTrigger(timeOfDay: lunch)
        #expect(trigger == .boredom)
    }

    @Test func suggestedTriggerReturnsStressWeekdayAfternoon() {
        var components = DateComponents()
        components.hour = 15
        let afternoon = Calendar.current.date(from: components) ?? .now
        let trigger = TriggerAnalyzer.suggestedTrigger(timeOfDay: afternoon, dayOfWeek: 4)
        #expect(trigger == .stress)
    }

    @Test func analyzePatternsCountsTriggers() {
        let sessions = [
            ScrollSession(userId: "u1", trigger: .stress, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .stress, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .boredom, startedAt: .now),
        ]
        let patterns = TriggerAnalyzer.analyzePatterns(sessions: sessions)
        #expect(patterns.first?.trigger == .stress)
        #expect(patterns.first?.count == 2)
    }

    @Test func analyzePatternsIgnoresNilTriggers() {
        let sessions = [
            ScrollSession(userId: "u1", trigger: nil, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .boredom, startedAt: .now),
        ]
        let patterns = TriggerAnalyzer.analyzePatterns(sessions: sessions)
        #expect(patterns.count == 1)
        #expect(patterns.first?.trigger == .boredom)
    }

    @Test func analyzePatternsReturnsEmptyForNoSessions() {
        let patterns = TriggerAnalyzer.analyzePatterns(sessions: [])
        #expect(patterns.isEmpty)
    }

    @Test func analyzePatternsIsSortedDescending() {
        let sessions = [
            ScrollSession(userId: "u1", trigger: .boredom, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .stress, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .stress, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .stress, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .boredom, startedAt: .now),
        ]
        let patterns = TriggerAnalyzer.analyzePatterns(sessions: sessions)
        #expect(patterns[0].count >= patterns[1].count)
    }

    @Test func topTriggerReturnsMostFrequent() {
        let sessions = [
            ScrollSession(userId: "u1", trigger: .anxiety, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .anxiety, startedAt: .now),
            ScrollSession(userId: "u1", trigger: .boredom, startedAt: .now),
        ]
        #expect(TriggerAnalyzer.topTrigger(from: sessions) == .anxiety)
    }

    @Test func topTriggerReturnsNilForEmptyInput() {
        #expect(TriggerAnalyzer.topTrigger(from: []) == nil)
    }
}

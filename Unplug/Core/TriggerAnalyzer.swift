import Foundation

enum TriggerAnalyzer {

    static func suggestedTrigger(
        timeOfDay: Date = .now,
        dayOfWeek: Int? = nil
    ) -> Trigger? {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: timeOfDay)
        let weekday = dayOfWeek ?? calendar.component(.weekday, from: timeOfDay)
        let isWeekend = weekday == 1 || weekday == 7

        switch hour {
        case 0..<6:
            return .insomnia
        case 6..<9:
            return isWeekend ? .habit : .procrastination
        case 9..<12:
            return .procrastination
        case 12..<14:
            return .boredom
        case 14..<17:
            return isWeekend ? .boredom : .stress
        case 17..<20:
            return .habit
        case 20..<22:
            return isWeekend ? .loneliness : .boredom
        default:
            return .insomnia
        }
    }

    static func analyzePatterns(sessions: [ScrollSession]) -> [(trigger: Trigger, count: Int)] {
        var counts: [Trigger: Int] = [:]
        for session in sessions {
            if let trigger = session.trigger {
                counts[trigger, default: 0] += 1
            }
        }
        return counts
            .map { (trigger: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }

    static func topTrigger(from sessions: [ScrollSession]) -> Trigger? {
        analyzePatterns(sessions: sessions).first?.trigger
    }
}

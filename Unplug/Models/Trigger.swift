import Foundation

enum Trigger: String, Codable, CaseIterable, Identifiable, Sendable {
    case boredom
    case stress
    case procrastination
    case habit
    case fomo
    case loneliness
    case anxiety
    case insomnia

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .boredom: return String(localized: "trigger.boredom")
        case .stress: return String(localized: "trigger.stress")
        case .procrastination: return String(localized: "trigger.procrastination")
        case .habit: return String(localized: "trigger.habit")
        case .fomo: return String(localized: "trigger.fomo")
        case .loneliness: return String(localized: "trigger.loneliness")
        case .anxiety: return String(localized: "trigger.anxiety")
        case .insomnia: return String(localized: "trigger.insomnia")
        }
    }

    var emoji: String {
        switch self {
        case .boredom: return "😑"
        case .stress: return "😰"
        case .procrastination: return "🫠"
        case .habit: return "🔄"
        case .fomo: return "📱"
        case .loneliness: return "😔"
        case .anxiety: return "😟"
        case .insomnia: return "🌙"
        }
    }
}

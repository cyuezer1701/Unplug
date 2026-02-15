import SwiftUI

@Observable
final class OnboardingState {
    var currentStep: OnboardingStep = .welcome
    var selectedTriggers: Set<Trigger> = []
    var selectedGoals: [String] = []
    var customGoal: String = ""
    var screenTimePermissionGranted: Bool = false
    var notificationsEnabled: Bool = false
    var dailyCheckInTime: Date = OnboardingState.defaultCheckInTime()

    var canProceed: Bool {
        switch currentStep {
        case .welcome:
            return true
        case .triggers:
            return !selectedTriggers.isEmpty
        case .goals:
            return !selectedGoals.isEmpty
        case .screenTime:
            return true
        case .notifications:
            return true
        }
    }

    var progress: Double {
        Double(currentStep.rawValue + 1) / Double(OnboardingStep.allCases.count)
    }

    func advance() {
        guard let next = currentStep.next else { return }
        currentStep = next
    }

    func goBack() {
        guard let prev = currentStep.previous else { return }
        currentStep = prev
    }

    static func defaultCheckInTime() -> Date {
        var components = DateComponents()
        components.hour = 21
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
}

enum OnboardingStep: Int, CaseIterable, Sendable {
    case welcome = 0
    case triggers = 1
    case goals = 2
    case screenTime = 3
    case notifications = 4

    var next: OnboardingStep? {
        OnboardingStep(rawValue: rawValue + 1)
    }

    var previous: OnboardingStep? {
        OnboardingStep(rawValue: rawValue - 1)
    }
}

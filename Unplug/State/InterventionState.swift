import SwiftUI

@Observable
final class InterventionState {
    var currentStep: InterventionStep = .selectTrigger
    var selectedTrigger: Trigger?
    var selectedAlternative: Alternative?
    var moodBefore: Int = 0
    var moodAfter: Int = 0
    var notes: String = ""
    var isActive: Bool = false
    var startedAt: Date?

    var canProceed: Bool {
        switch currentStep {
        case .selectTrigger:
            return selectedTrigger != nil
        case .choosingAlternative:
            return selectedAlternative != nil
        case .doingActivity:
            return true
        case .logSession:
            return moodAfter > 0
        }
    }

    var progress: Double {
        Double(currentStep.rawValue + 1) / Double(InterventionStep.allCases.count)
    }

    func start() {
        reset()
        isActive = true
        startedAt = .now
    }

    func selectTrigger(_ trigger: Trigger) {
        selectedTrigger = trigger
    }

    func selectAlternative(_ alternative: Alternative) {
        selectedAlternative = alternative
    }

    func advance() {
        guard canProceed, let next = currentStep.next else { return }
        currentStep = next
    }

    func goBack() {
        guard let prev = currentStep.previous else { return }
        currentStep = prev
    }

    func complete() {
        isActive = false
    }

    func reset() {
        currentStep = .selectTrigger
        selectedTrigger = nil
        selectedAlternative = nil
        moodBefore = 0
        moodAfter = 0
        notes = ""
        isActive = false
        startedAt = nil
    }
}

enum InterventionStep: Int, CaseIterable, Sendable {
    case selectTrigger = 0
    case choosingAlternative = 1
    case doingActivity = 2
    case logSession = 3

    var next: InterventionStep? {
        InterventionStep(rawValue: rawValue + 1)
    }

    var previous: InterventionStep? {
        InterventionStep(rawValue: rawValue - 1)
    }
}

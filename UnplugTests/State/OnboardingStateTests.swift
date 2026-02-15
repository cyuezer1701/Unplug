import Foundation
import Testing
@testable import Unplug

struct OnboardingStateTests {
    // MARK: - Initial State

    @Test func initialStepIsWelcome() {
        let state = OnboardingState()
        #expect(state.currentStep == .welcome)
    }

    @Test func initialTriggersAreEmpty() {
        let state = OnboardingState()
        #expect(state.selectedTriggers.isEmpty)
    }

    @Test func initialGoalsAreEmpty() {
        let state = OnboardingState()
        #expect(state.selectedGoals.isEmpty)
    }

    // MARK: - Navigation

    @Test func advanceMovesToTriggers() {
        let state = OnboardingState()
        state.advance()
        #expect(state.currentStep == .triggers)
    }

    @Test func advanceThroughAllSteps() {
        let state = OnboardingState()
        state.advance() // → triggers
        state.advance() // → goals
        state.advance() // → screenTime
        state.advance() // → notifications
        #expect(state.currentStep == .notifications)
    }

    @Test func advanceBeyondLastStepStaysAtLast() {
        let state = OnboardingState()
        state.currentStep = .notifications
        state.advance()
        #expect(state.currentStep == .notifications)
    }

    @Test func goBackFromTriggersReturnsToWelcome() {
        let state = OnboardingState()
        state.currentStep = .triggers
        state.goBack()
        #expect(state.currentStep == .welcome)
    }

    @Test func goBackFromWelcomeStaysAtWelcome() {
        let state = OnboardingState()
        state.goBack()
        #expect(state.currentStep == .welcome)
    }

    // MARK: - Progress

    @Test func progressAtWelcomeIsOneFifth() {
        let state = OnboardingState()
        #expect(state.progress == 1.0 / 5.0)
    }

    @Test func progressAtNotificationsIsFull() {
        let state = OnboardingState()
        state.currentStep = .notifications
        #expect(state.progress == 1.0)
    }

    @Test func progressIncrementsCorrectly() {
        let state = OnboardingState()
        let expectedSteps: [OnboardingStep] = [.welcome, .triggers, .goals, .screenTime, .notifications]
        for (index, step) in expectedSteps.enumerated() {
            state.currentStep = step
            let expected = Double(index + 1) / 5.0
            #expect(abs(state.progress - expected) < 0.001, "Progress at \(step) should be \(expected)")
        }
    }

    // MARK: - canProceed

    @Test func canAlwaysProceedFromWelcome() {
        let state = OnboardingState()
        #expect(state.canProceed == true)
    }

    @Test func cannotProceedFromTriggersWithoutSelection() {
        let state = OnboardingState()
        state.currentStep = .triggers
        #expect(state.canProceed == false)
    }

    @Test func canProceedFromTriggersWithSelection() {
        let state = OnboardingState()
        state.currentStep = .triggers
        state.selectedTriggers.insert(.boredom)
        #expect(state.canProceed == true)
    }

    @Test func cannotProceedFromGoalsWithoutSelection() {
        let state = OnboardingState()
        state.currentStep = .goals
        #expect(state.canProceed == false)
    }

    @Test func canProceedFromGoalsWithSelection() {
        let state = OnboardingState()
        state.currentStep = .goals
        state.selectedGoals = ["Read more"]
        #expect(state.canProceed == true)
    }

    @Test func canAlwaysProceedFromScreenTime() {
        let state = OnboardingState()
        state.currentStep = .screenTime
        #expect(state.canProceed == true)
    }

    @Test func canAlwaysProceedFromNotifications() {
        let state = OnboardingState()
        state.currentStep = .notifications
        #expect(state.canProceed == true)
    }
}

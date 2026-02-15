import Foundation
import Testing
@testable import Unplug

@Suite("InterventionState Tests")
struct InterventionStateTests {

    @Test func initialStateIsSelectTrigger() {
        let state = InterventionState()
        #expect(state.currentStep == .selectTrigger)
        #expect(state.isActive == false)
        #expect(state.selectedTrigger == nil)
        #expect(state.selectedAlternative == nil)
    }

    @Test func startActivatesAndResetsState() {
        let state = InterventionState()
        state.selectedTrigger = .boredom
        state.start()
        #expect(state.isActive == true)
        #expect(state.selectedTrigger == nil)
        #expect(state.currentStep == .selectTrigger)
        #expect(state.startedAt != nil)
    }

    @Test func cannotProceedWithoutTriggerOnFirstStep() {
        let state = InterventionState()
        #expect(state.canProceed == false)
    }

    @Test func canProceedAfterSelectingTrigger() {
        let state = InterventionState()
        state.selectTrigger(.stress)
        #expect(state.canProceed == true)
        #expect(state.selectedTrigger == .stress)
    }

    @Test func advanceMovesToNextStep() {
        let state = InterventionState()
        state.selectTrigger(.boredom)
        state.advance()
        #expect(state.currentStep == .choosingAlternative)
    }

    @Test func advanceDoesNothingWhenCannotProceed() {
        let state = InterventionState()
        state.advance()
        #expect(state.currentStep == .selectTrigger)
    }

    @Test func cannotProceedOnChoosingAlternativeWithoutSelection() {
        let state = InterventionState()
        state.selectTrigger(.boredom)
        state.advance()
        #expect(state.canProceed == false)
    }

    @Test func canProceedOnChoosingAlternativeWithSelection() {
        let state = InterventionState()
        state.selectTrigger(.boredom)
        state.advance()
        let alt = Alternative(title: "Test", description: "Test", category: .movement)
        state.selectAlternative(alt)
        #expect(state.canProceed == true)
    }

    @Test func canAlwaysProceedFromDoingActivity() {
        let state = InterventionState()
        state.selectTrigger(.boredom)
        state.advance()
        let alt = Alternative(title: "Test", description: "Test", category: .movement)
        state.selectAlternative(alt)
        state.advance()
        #expect(state.currentStep == .doingActivity)
        #expect(state.canProceed == true)
    }

    @Test func cannotProceedFromLogSessionWithoutMood() {
        let state = InterventionState()
        state.selectTrigger(.boredom)
        state.advance()
        let alt = Alternative(title: "Test", description: "Test", category: .movement)
        state.selectAlternative(alt)
        state.advance()
        state.advance()
        #expect(state.currentStep == .logSession)
        #expect(state.canProceed == false)
    }

    @Test func canProceedFromLogSessionWithMood() {
        let state = InterventionState()
        state.selectTrigger(.boredom)
        state.advance()
        let alt = Alternative(title: "Test", description: "Test", category: .movement)
        state.selectAlternative(alt)
        state.advance()
        state.advance()
        state.moodAfter = 4
        #expect(state.canProceed == true)
    }

    @Test func goBackReturnsToPreviousStep() {
        let state = InterventionState()
        state.selectTrigger(.boredom)
        state.advance()
        state.goBack()
        #expect(state.currentStep == .selectTrigger)
    }

    @Test func goBackDoesNothingOnFirstStep() {
        let state = InterventionState()
        state.goBack()
        #expect(state.currentStep == .selectTrigger)
    }

    @Test func progressIncreasesWithSteps() {
        let state = InterventionState()
        let initial = state.progress
        state.selectTrigger(.boredom)
        state.advance()
        #expect(state.progress > initial)
    }

    @Test func completeDeactivatesState() {
        let state = InterventionState()
        state.start()
        state.complete()
        #expect(state.isActive == false)
    }

    @Test func resetClearsAllState() {
        let state = InterventionState()
        state.start()
        state.selectTrigger(.stress)
        state.moodBefore = 3
        state.moodAfter = 5
        state.notes = "Test note"
        state.reset()

        #expect(state.currentStep == .selectTrigger)
        #expect(state.selectedTrigger == nil)
        #expect(state.moodBefore == 0)
        #expect(state.moodAfter == 0)
        #expect(state.notes == "")
        #expect(state.isActive == false)
        #expect(state.startedAt == nil)
    }

    @Test func cannotAdvancePastLastStep() {
        let state = InterventionState()
        state.selectTrigger(.boredom)
        state.advance()
        let alt = Alternative(title: "T", description: "T", category: .movement)
        state.selectAlternative(alt)
        state.advance()
        state.advance()
        state.moodAfter = 4
        state.advance()
        #expect(state.currentStep == .logSession)
    }
}

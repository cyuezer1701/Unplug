import Foundation
import Testing
@testable import Unplug

struct GoalValidatorTests {
    // MARK: - isValidGoal

    @Test func validGoalIsAccepted() {
        #expect(GoalValidator.isValidGoal("Read a book instead of scrolling") == true)
    }

    @Test func minimumLengthGoalIsAccepted() {
        #expect(GoalValidator.isValidGoal("Hello") == true)
    }

    @Test func tooShortGoalIsRejected() {
        #expect(GoalValidator.isValidGoal("Hi") == false)
    }

    @Test func emptyGoalIsRejected() {
        #expect(GoalValidator.isValidGoal("") == false)
    }

    @Test func whitespaceOnlyGoalIsRejected() {
        #expect(GoalValidator.isValidGoal("     ") == false)
    }

    @Test func goalWithLeadingWhitespaceIsTrimmed() {
        #expect(GoalValidator.isValidGoal("   Read more books   ") == true)
    }

    @Test func veryLongGoalIsRejected() {
        let longGoal = String(repeating: "a", count: 201)
        #expect(GoalValidator.isValidGoal(longGoal) == false)
    }

    @Test func maxLengthGoalIsAccepted() {
        let maxGoal = String(repeating: "a", count: 200)
        #expect(GoalValidator.isValidGoal(maxGoal) == true)
    }

    // MARK: - validateGoalSelection

    @Test func emptySelectionIsInvalid() {
        #expect(GoalValidator.validateGoalSelection([]) == false)
    }

    @Test func singleGoalSelectionIsValid() {
        #expect(GoalValidator.validateGoalSelection(["Goal 1"]) == true)
    }

    @Test func fiveGoalsIsValid() {
        let goals = (1...5).map { "Goal \($0)" }
        #expect(GoalValidator.validateGoalSelection(goals) == true)
    }

    @Test func sixGoalsIsInvalid() {
        let goals = (1...6).map { "Goal \($0)" }
        #expect(GoalValidator.validateGoalSelection(goals) == false)
    }

    // MARK: - presetGoals

    @Test func presetGoalsAreNotEmpty() {
        #expect(!GoalValidator.presetGoals.isEmpty)
    }

    @Test func allPresetGoalsAreValid() {
        for goal in GoalValidator.presetGoals {
            #expect(GoalValidator.isValidGoal(goal), "Preset goal '\(goal)' should be valid")
        }
    }
}

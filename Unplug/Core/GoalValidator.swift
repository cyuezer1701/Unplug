import Foundation

enum GoalValidator {
    static let presetGoals: [String] = [
        "Reduce screen time by 30 minutes daily",
        "No phone for first hour after waking",
        "No scrolling after 10 PM",
        "Replace scrolling with reading",
        "Take 3 mindful breaks per day",
        "No social media during meals",
        "One phone-free evening per week",
        "Walk instead of scroll when bored",
    ]

    static func isValidGoal(_ goal: String) -> Bool {
        let trimmed = goal.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count >= 5 && trimmed.count <= 200
    }

    static func validateGoalSelection(_ goals: [String]) -> Bool {
        goals.count >= 1 && goals.count <= 5
    }
}

import SwiftUI

struct AchievementGalleryView: View {
    @Environment(AppState.self) private var appState

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: UnplugTheme.Spacing.md) {
                ForEach(allAchievements) { item in
                    AchievementCard(
                        achievement: item.achievement,
                        isUnlocked: item.isUnlocked
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(UnplugTheme.Spacing.lg)
        }
        .navigationTitle(String(localized: "achievements.title"))
        .unplugBackground()
    }

    private var allAchievements: [AchievementItem] {
        let userId = appState.currentUser?.id ?? ""
        let unlockedTypes = Set(appState.achievements.map(\.type))

        return AchievementType.allCases.map { type in
            if let existing = appState.achievements.first(where: { $0.type == type }) {
                return AchievementItem(achievement: existing, isUnlocked: true)
            } else {
                let placeholder = AchievementChecker.createAchievement(type: type, userId: userId)
                return AchievementItem(achievement: placeholder, isUnlocked: false)
            }
        }
    }
}

private struct AchievementItem: Identifiable {
    let achievement: Achievement
    let isUnlocked: Bool
    var id: String { achievement.type.rawValue }
}

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: UnplugTheme.Spacing.lg) {
                    // Greeting
                    Text("Welcome back")
                        .font(.unplugTitle())
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Today's progress
                    UnplugCard {
                        HStack {
                            VStack(alignment: .leading, spacing: UnplugTheme.Spacing.xs) {
                                Text("Today's Screen Time")
                                    .font(.unplugCaption())
                                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                                Text("0 min")
                                    .font(.unplugHeadline())
                            }
                            Spacer()
                            ProgressRing(progress: 0, size: 60)
                        }
                    }

                    // Streak
                    UnplugCard {
                        HStack {
                            VStack(alignment: .leading, spacing: UnplugTheme.Spacing.xs) {
                                Text("Current Streak")
                                    .font(.unplugCaption())
                                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                                HStack(spacing: UnplugTheme.Spacing.xs) {
                                    StreakBadge(count: appState.currentStreak?.currentCount ?? 0)
                                }
                            }
                            Spacer()
                        }
                    }

                    // Quick action
                    UnplugCard {
                        VStack(alignment: .leading, spacing: UnplugTheme.Spacing.sm) {
                            Text("Feeling the urge to scroll?")
                                .font(.unplugSubheadline())
                            Text("Tap here to get a better alternative for right now.")
                                .font(.unplugBody())
                                .foregroundStyle(UnplugTheme.Colors.textSecondary)

                            UnplugButton(title: "I'm reaching for my phone", style: .primary) {
                                // Phase 2: Open intervention/alternative flow
                            }
                        }
                    }
                }
                .padding(UnplugTheme.Spacing.lg)
            }
            .navigationTitle("Home")
            .unplugBackground()
        }
    }
}

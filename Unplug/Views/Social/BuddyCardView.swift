import SwiftUI

struct BuddyCardView: View {
    let buddy: BuddyInfo
    let progress: BuddyProgress?

    var body: some View {
        UnplugCard {
            HStack(spacing: UnplugTheme.Spacing.md) {
                // Avatar
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(UnplugTheme.Colors.primarySage.opacity(0.6))

                VStack(alignment: .leading, spacing: UnplugTheme.Spacing.xxs) {
                    Text(buddy.displayName.isEmpty
                        ? String(localized: "social.buddy.anonymous")
                        : buddy.displayName)
                        .font(.unplugCallout())
                        .foregroundStyle(UnplugTheme.Colors.textPrimary)

                    HStack(spacing: UnplugTheme.Spacing.sm) {
                        StreakBadge(
                            count: progress?.currentStreak ?? buddy.streakCount,
                            isActive: true
                        )

                        if let mood = progress?.latestMoodLevel {
                            Text(moodEmoji(mood))
                                .font(.title3)
                        }
                    }
                }

                Spacer()

                if let progress {
                    VStack(alignment: .trailing, spacing: UnplugTheme.Spacing.xxs) {
                        Text("\(progress.todaySessionCount)")
                            .font(.unplugSubheadline())
                        Text(String(localized: "social.buddy.today"))
                            .font(.unplugCaption())
                            .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    }
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(buddy.displayName), \(buddy.streakCount) day streak")
    }

    private func moodEmoji(_ level: Int) -> String {
        switch level {
        case 1: return "😢"
        case 2: return "😕"
        case 3: return "😐"
        case 4: return "😊"
        case 5: return "😄"
        default: return "😐"
        }
    }
}

import SwiftUI

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.sm) {
            Image(systemName: achievement.iconName)
                .font(.system(size: 32))
                .foregroundStyle(isUnlocked ? UnplugTheme.Colors.primarySage : UnplugTheme.Colors.textSecondary.opacity(0.3))
                .frame(height: 40)

            Text(isUnlocked ? achievement.title : "???")
                .font(.unplugCallout())
                .foregroundStyle(isUnlocked ? UnplugTheme.Colors.textPrimary : UnplugTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            if isUnlocked, let date = achievement.unlockedAt {
                Text(date, style: .date)
                    .font(.unplugCaption())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
            }
        }
        .padding(UnplugTheme.Spacing.md)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: UnplugTheme.Radius.lg)
                .fill(isUnlocked
                    ? UnplugTheme.Colors.primarySage.opacity(0.1)
                    : UnplugTheme.Colors.surfaceCard)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(isUnlocked
            ? String(localized: "achievement.unlocked.label \(achievement.title)")
            : String(localized: "achievement.locked.label"))
    }
}

import SwiftUI

struct StreakBadge: View {
    let count: Int
    var isActive: Bool = true

    var body: some View {
        HStack(spacing: UnplugTheme.Spacing.xxs) {
            Image(systemName: "flame.fill")
                .foregroundStyle(isActive ? UnplugTheme.Colors.accentCoral : UnplugTheme.Colors.textSecondary)
                .symbolEffect(.bounce, value: count)

            Text("\(count)")
                .font(.unplugSubheadline())
                .foregroundStyle(isActive ? UnplugTheme.Colors.textPrimary : UnplugTheme.Colors.textSecondary)
        }
        .padding(.horizontal, UnplugTheme.Spacing.sm)
        .padding(.vertical, UnplugTheme.Spacing.xs)
        .background(
            Capsule()
                .fill(UnplugTheme.Colors.surfaceCard)
        )
        .accessibilityLabel("\(count) day streak")
    }
}

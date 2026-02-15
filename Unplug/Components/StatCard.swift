import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var color: Color = UnplugTheme.Colors.primarySage

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.xs) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)

            Text(value)
                .font(.unplugHeadline())
                .foregroundStyle(UnplugTheme.Colors.textPrimary)

            Text(title)
                .font(.unplugCaption())
                .foregroundStyle(UnplugTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(UnplugTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: UnplugTheme.Radius.md)
                .fill(UnplugTheme.Colors.surfaceCard)
                .shadow(color: .black.opacity(0.03), radius: 2, y: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}

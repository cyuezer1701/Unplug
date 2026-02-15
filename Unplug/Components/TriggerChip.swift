import SwiftUI

struct TriggerChip: View {
    let trigger: Trigger
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: UnplugTheme.Spacing.xs) {
                Text(trigger.emoji)
                    .font(.title3)
                Text(trigger.displayName)
                    .font(.unplugCallout())
            }
            .padding(.horizontal, UnplugTheme.Spacing.md)
            .padding(.vertical, UnplugTheme.Spacing.sm)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: UnplugTheme.Radius.lg)
                    .fill(isSelected ? UnplugTheme.Colors.primarySage : UnplugTheme.Colors.surfaceCard)
            )
            .foregroundStyle(isSelected ? .white : UnplugTheme.Colors.textPrimary)
        }
        .accessibilityLabel(trigger.displayName)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

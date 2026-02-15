import SwiftUI

struct TriggerPickerView: View {
    let state: InterventionState

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.lg) {
            VStack(spacing: UnplugTheme.Spacing.sm) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(UnplugTheme.Colors.accentCoral)

                Text(String(localized: "intervention.trigger.title"))
                    .font(.unplugHeadline())

                Text(String(localized: "intervention.trigger.subtitle"))
                    .font(.unplugBody())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.md)
            }
            .padding(.top, UnplugTheme.Spacing.xl)

            ScrollView {
                LazyVGrid(columns: columns, spacing: UnplugTheme.Spacing.sm) {
                    ForEach(Trigger.allCases) { trigger in
                        TriggerChip(
                            trigger: trigger,
                            isSelected: state.selectedTrigger == trigger
                        ) {
                            HapticService.selection()
                            withAnimation(.unplugSpring) {
                                state.selectTrigger(trigger)
                            }
                        }
                    }
                }
                .padding(.horizontal, UnplugTheme.Spacing.lg)
            }

            Spacer()

            UnplugButton(
                title: String(localized: "intervention.next"),
                isDisabled: !state.canProceed
            ) {
                withAnimation(.unplugSpring) {
                    state.advance()
                }
            }
            .padding(.horizontal, UnplugTheme.Spacing.lg)
            .padding(.bottom, UnplugTheme.Spacing.xxl)
        }
    }
}

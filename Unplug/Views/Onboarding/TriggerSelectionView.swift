import SwiftUI

struct TriggerSelectionView: View {
    let state: OnboardingState

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.lg) {
            VStack(spacing: UnplugTheme.Spacing.sm) {
                Text("Why do you scroll?")
                    .font(.unplugHeadline())

                Text("Select the triggers that make you reach for your phone mindlessly.")
                    .font(.unplugBody())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.md)
            }
            .padding(.top, UnplugTheme.Spacing.lg)

            ScrollView {
                LazyVGrid(columns: columns, spacing: UnplugTheme.Spacing.sm) {
                    ForEach(Trigger.allCases) { trigger in
                        TriggerChip(
                            trigger: trigger,
                            isSelected: state.selectedTriggers.contains(trigger)
                        ) {
                            withAnimation(.unplugSpring) {
                                if state.selectedTriggers.contains(trigger) {
                                    state.selectedTriggers.remove(trigger)
                                } else {
                                    state.selectedTriggers.insert(trigger)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, UnplugTheme.Spacing.lg)
            }

            Spacer()

            HStack(spacing: UnplugTheme.Spacing.sm) {
                UnplugButton(
                    title: "Back",
                    style: .secondary
                ) {
                    state.goBack()
                }

                UnplugButton(
                    title: "Next",
                    isDisabled: !state.canProceed
                ) {
                    state.advance()
                }
            }
            .padding(.horizontal, UnplugTheme.Spacing.lg)
            .padding(.bottom, UnplugTheme.Spacing.xxl)
        }
    }
}

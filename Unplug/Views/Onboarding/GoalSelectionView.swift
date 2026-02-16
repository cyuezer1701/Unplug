import SwiftUI

struct GoalSelectionView: View {
    let state: OnboardingState
    @State private var showCustomGoalField = false

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.lg) {
            VStack(spacing: UnplugTheme.Spacing.sm) {
                Text(String(localized: "onboarding.goals.title"))
                    .font(.unplugHeadline())

                Text(String(localized: "onboarding.goals.description"))
                    .font(.unplugBody())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.md)
            }
            .padding(.top, UnplugTheme.Spacing.lg)

            ScrollView {
                VStack(spacing: UnplugTheme.Spacing.sm) {
                    ForEach(GoalValidator.presetGoals, id: \.self) { goal in
                        GoalRow(
                            title: goal,
                            isSelected: state.selectedGoals.contains(goal)
                        ) {
                            withAnimation(.unplugSpring) {
                                if state.selectedGoals.contains(goal) {
                                    state.selectedGoals.removeAll { $0 == goal }
                                } else if state.selectedGoals.count < 5 {
                                    state.selectedGoals.append(goal)
                                }
                            }
                        }
                    }

                    if showCustomGoalField {
                        HStack {
                            TextField(
                                String(localized: "onboarding.goals.custom.placeholder"),
                                text: Binding(
                                    get: { state.customGoal },
                                    set: { state.customGoal = $0 }
                                )
                            )
                            .font(.unplugBody())
                            .textFieldStyle(.roundedBorder)

                            Button {
                                if GoalValidator.isValidGoal(state.customGoal) {
                                    state.selectedGoals.append(state.customGoal)
                                    state.customGoal = ""
                                    showCustomGoalField = false
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(UnplugTheme.Colors.primarySage)
                            }
                        }
                        .padding(.horizontal, UnplugTheme.Spacing.md)
                    } else {
                        Button {
                            showCustomGoalField = true
                        } label: {
                            Label(String(localized: "onboarding.goals.custom.add"), systemImage: "plus.circle")
                                .font(.unplugCallout())
                                .foregroundStyle(UnplugTheme.Colors.primarySage)
                        }
                    }
                }
                .padding(.horizontal, UnplugTheme.Spacing.lg)
            }

            Spacer()

            HStack(spacing: UnplugTheme.Spacing.sm) {
                UnplugButton(title: String(localized: "button.back"), style: .secondary) {
                    state.goBack()
                }
                UnplugButton(
                    title: String(localized: "button.next"),
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

struct GoalRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.unplugBody())
                    .foregroundStyle(isSelected ? .white : UnplugTheme.Colors.textPrimary)
                    .multilineTextAlignment(.leading)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.white)
                }
            }
            .padding(UnplugTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: UnplugTheme.Radius.md)
                    .fill(isSelected ? UnplugTheme.Colors.primarySage : UnplugTheme.Colors.surfaceCard)
            )
        }
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

import SwiftUI

struct EditGoalsView: View {
    let appState: AppState
    let viewModel: SettingsViewModel
    @State private var selectedGoals: [String] = []
    @State private var isSaving = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.lg) {
            ScrollView {
                VStack(spacing: UnplugTheme.Spacing.sm) {
                    ForEach(GoalValidator.presetGoals, id: \.self) { goal in
                        Button {
                            withAnimation(.unplugSpring) {
                                if selectedGoals.contains(goal) {
                                    selectedGoals.removeAll { $0 == goal }
                                } else if selectedGoals.count < 5 {
                                    selectedGoals.append(goal)
                                }
                            }
                        } label: {
                            HStack {
                                Text(goal)
                                    .font(.unplugBody())
                                    .foregroundStyle(UnplugTheme.Colors.textPrimary)
                                Spacer()
                                if selectedGoals.contains(goal) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(UnplugTheme.Colors.primarySage)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                                }
                            }
                            .padding(UnplugTheme.Spacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: UnplugTheme.Radius.md)
                                    .fill(selectedGoals.contains(goal)
                                        ? UnplugTheme.Colors.primarySage.opacity(0.1)
                                        : UnplugTheme.Colors.surfaceCard)
                            )
                        }
                    }
                }
                .padding(.horizontal, UnplugTheme.Spacing.lg)
            }

            UnplugButton(
                title: String(localized: "settings.save"),
                isDisabled: selectedGoals.isEmpty,
                isLoading: isSaving
            ) {
                save()
            }
            .padding(.horizontal, UnplugTheme.Spacing.lg)
            .padding(.bottom, UnplugTheme.Spacing.lg)
        }
        .navigationTitle(String(localized: "settings.goals"))
        .onAppear {
            selectedGoals = appState.currentUser?.goals ?? []
        }
    }

    private func save() {
        isSaving = true
        Task {
            try? await viewModel.updateGoals(selectedGoals, appState: appState)
            isSaving = false
            dismiss()
        }
    }
}

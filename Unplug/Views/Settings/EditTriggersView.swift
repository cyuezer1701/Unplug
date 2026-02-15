import SwiftUI

struct EditTriggersView: View {
    let appState: AppState
    let viewModel: SettingsViewModel
    @State private var selectedTriggers: Set<Trigger> = []
    @State private var isSaving = false
    @Environment(\.dismiss) private var dismiss

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.lg) {
            Text(String(localized: "settings.triggers.description"))
                .font(.unplugBody())
                .foregroundStyle(UnplugTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, UnplugTheme.Spacing.lg)

            ScrollView {
                LazyVGrid(columns: columns, spacing: UnplugTheme.Spacing.sm) {
                    ForEach(Trigger.allCases) { trigger in
                        TriggerChip(
                            trigger: trigger,
                            isSelected: selectedTriggers.contains(trigger)
                        ) {
                            withAnimation(.unplugSpring) {
                                if selectedTriggers.contains(trigger) {
                                    selectedTriggers.remove(trigger)
                                } else {
                                    selectedTriggers.insert(trigger)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, UnplugTheme.Spacing.lg)
            }

            UnplugButton(
                title: String(localized: "settings.save"),
                isDisabled: selectedTriggers.isEmpty,
                isLoading: isSaving
            ) {
                save()
            }
            .padding(.horizontal, UnplugTheme.Spacing.lg)
            .padding(.bottom, UnplugTheme.Spacing.lg)
        }
        .navigationTitle(String(localized: "settings.triggers"))
        .onAppear {
            selectedTriggers = Set(appState.currentUser?.triggers ?? [])
        }
    }

    private func save() {
        isSaving = true
        Task {
            try? await viewModel.updateTriggers(Array(selectedTriggers), appState: appState)
            isSaving = false
            dismiss()
        }
    }
}

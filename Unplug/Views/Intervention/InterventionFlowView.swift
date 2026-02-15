import SwiftUI

struct InterventionFlowView: View {
    @Environment(AppState.self) private var appState
    let interventionState: InterventionState

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress bar
                ProgressView(value: interventionState.progress)
                    .tint(UnplugTheme.Colors.primarySage)
                    .padding(.horizontal, UnplugTheme.Spacing.lg)
                    .padding(.top, UnplugTheme.Spacing.sm)
                    .animation(.unplugGentle, value: interventionState.progress)

                // Step content
                Group {
                    switch interventionState.currentStep {
                    case .selectTrigger:
                        TriggerPickerView(state: interventionState)
                    case .choosingAlternative:
                        AlternativeListView(state: interventionState)
                    case .doingActivity:
                        ActivityTimerView(state: interventionState)
                    case .logSession:
                        SessionCompleteView(state: interventionState)
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .animation(.unplugSpring, value: interventionState.currentStep)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        interventionState.reset()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    }
                    .accessibilityLabel(String(localized: "intervention.close"))
                }
            }
        }
    }
}

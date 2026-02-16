import FamilyControls
import SwiftUI

struct AppSelectionView: View {
    let state: OnboardingState

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.lg) {
            VStack(spacing: UnplugTheme.Spacing.sm) {
                Text(String(localized: "onboarding.appselection.title"))
                    .font(.unplugHeadline())
                    .multilineTextAlignment(.center)

                Text(String(localized: "onboarding.appselection.description"))
                    .font(.unplugBody())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.md)
            }
            .padding(.top, UnplugTheme.Spacing.lg)

            if selectionCount > 0 {
                HStack(spacing: UnplugTheme.Spacing.xs) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(UnplugTheme.Colors.success)
                    Text(String(localized: "onboarding.appselection.selected \(selectionCount)"))
                        .font(.unplugCaption())
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                }
            }

            FamilyActivityPicker(
                selection: Binding(
                    get: { state.monitoredAppsSelection },
                    set: { state.monitoredAppsSelection = $0 }
                )
            )
            .padding(.horizontal, UnplugTheme.Spacing.sm)

            VStack(spacing: UnplugTheme.Spacing.sm) {
                HStack(spacing: UnplugTheme.Spacing.sm) {
                    UnplugButton(
                        title: String(localized: "button.back"),
                        style: .secondary
                    ) {
                        state.goBack()
                    }

                    UnplugButton(
                        title: String(localized: "button.next")
                    ) {
                        UserPreferences.shared.saveMonitoredAppsSelection(
                            state.monitoredAppsSelection
                        )
                        state.advance()
                    }
                }

                Button {
                    state.advance()
                } label: {
                    Text(String(localized: "onboarding.appselection.skip"))
                        .font(.unplugCallout())
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                }
            }
            .padding(.horizontal, UnplugTheme.Spacing.lg)
            .padding(.bottom, UnplugTheme.Spacing.xxl)
        }
    }

    private var selectionCount: Int {
        state.monitoredAppsSelection.applicationTokens.count
            + state.monitoredAppsSelection.categoryTokens.count
    }
}

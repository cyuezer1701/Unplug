import FamilyControls
import SwiftUI

struct MonitoredAppsView: View {
    let viewModel: SettingsViewModel
    @State private var selection: FamilyActivitySelection

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        let saved = UserPreferences.shared.loadMonitoredAppsSelection()
        self._selection = State(initialValue: saved ?? FamilyActivitySelection())
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: UnplugTheme.Spacing.xs) {
                Text(String(localized: "settings.monitoredapps.description"))
                    .font(.unplugCaption())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.lg)
                    .padding(.top, UnplugTheme.Spacing.md)

                if selectionCount > 0 {
                    Text(String(localized: "settings.monitoredapps.count \(selectionCount)"))
                        .font(.unplugCaption())
                        .foregroundStyle(UnplugTheme.Colors.primarySage)
                        .padding(.bottom, UnplugTheme.Spacing.sm)
                } else {
                    Text(String(localized: "settings.monitoredapps.allApps"))
                        .font(.unplugCaption())
                        .foregroundStyle(UnplugTheme.Colors.accentCoral)
                        .padding(.bottom, UnplugTheme.Spacing.sm)
                }
            }

            FamilyActivityPicker(selection: $selection)
                .onChange(of: selection) { _, newSelection in
                    viewModel.updateMonitoredApps(newSelection)
                }
        }
        .navigationTitle(String(localized: "settings.monitoredapps"))
    }

    private var selectionCount: Int {
        selection.applicationTokens.count + selection.categoryTokens.count
    }
}

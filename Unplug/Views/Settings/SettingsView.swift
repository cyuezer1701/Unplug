import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(AuthService.self) private var authService
    @State private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section(String(localized: "settings.profile")) {
                    NavigationLink {
                        EditTriggersView(appState: appState, viewModel: viewModel)
                    } label: {
                        Label(String(localized: "settings.triggers"), systemImage: "bolt.circle")
                    }

                    NavigationLink {
                        EditGoalsView(appState: appState, viewModel: viewModel)
                    } label: {
                        Label(String(localized: "settings.goals"), systemImage: "target")
                    }
                }

                Section(String(localized: "settings.preferences")) {
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        Label(String(localized: "settings.notifications"), systemImage: "bell")
                    }

                    NavigationLink {
                        ScrollLimitView(viewModel: viewModel)
                    } label: {
                        Label(String(localized: "settings.scrolllimit"), systemImage: "timer")
                    }

                    NavigationLink {
                        MonitoredAppsView(viewModel: viewModel)
                    } label: {
                        Label(String(localized: "settings.monitoredapps"), systemImage: "apps.iphone")
                    }
                }

                Section(String(localized: "settings.about.section")) {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label(String(localized: "settings.about"), systemImage: "info.circle")
                    }
                }

                Section(String(localized: "settings.account")) {
                    Button {
                        viewModel.showingSignOutConfirmation = true
                    } label: {
                        Label(String(localized: "settings.signout"), systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        viewModel.showingResetConfirmation = true
                    } label: {
                        Label(String(localized: "settings.reset"), systemImage: "arrow.counterclockwise")
                    }
                }
            }
            .navigationTitle(String(localized: "tab.settings"))
            .alert(String(localized: "settings.reset.confirm.title"), isPresented: $viewModel.showingResetConfirmation) {
                Button(String(localized: "settings.reset.confirm.cancel"), role: .cancel) {}
                Button(String(localized: "settings.reset.confirm.action"), role: .destructive) {
                    Task {
                        try? await viewModel.resetApp(authService: authService, appState: appState)
                    }
                }
            } message: {
                Text(String(localized: "settings.reset.confirm.message"))
            }
            .alert(String(localized: "settings.signout.confirm.title"), isPresented: $viewModel.showingSignOutConfirmation) {
                Button(String(localized: "settings.signout.confirm.cancel"), role: .cancel) {}
                Button(String(localized: "settings.signout.confirm.action"), role: .destructive) {
                    try? viewModel.signOut(authService: authService, appState: appState)
                }
            }
        }
    }
}

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            List {
                Section("Profile") {
                    Label("Edit Triggers", systemImage: "bolt.circle")
                    Label("Edit Goals", systemImage: "target")
                    Label("Monitored Apps", systemImage: "app.badge")
                }

                Section("Preferences") {
                    Label("Notifications", systemImage: "bell")
                    Label("Daily Scroll Limit", systemImage: "timer")
                    Label("Appearance", systemImage: "paintbrush")
                }

                Section("Account") {
                    Label("Premium", systemImage: "crown")
                        .foregroundStyle(UnplugTheme.Colors.accentCoral)
                    Label("Privacy Policy", systemImage: "lock.shield")
                    Label("About Unplug", systemImage: "info.circle")
                }

                Section {
                    Button(role: .destructive) {
                        // Phase 2: Reset/logout flow
                    } label: {
                        Label("Reset App", systemImage: "arrow.counterclockwise")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

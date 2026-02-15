import SwiftUI

struct NotificationSettingsView: View {
    @State private var isEnabled = false
    @State private var reminderTime = OnboardingState.defaultCheckInTime()
    private let notificationService = NotificationService()

    var body: some View {
        List {
            Section {
                Toggle(String(localized: "settings.notifications.enable"), isOn: $isEnabled)
                    .tint(UnplugTheme.Colors.primarySage)
                    .onChange(of: isEnabled) { _, enabled in
                        handleToggle(enabled)
                    }

                if isEnabled {
                    DatePicker(
                        String(localized: "settings.notifications.time"),
                        selection: $reminderTime,
                        displayedComponents: .hourAndMinute
                    )
                    .onChange(of: reminderTime) { _, newTime in
                        Task {
                            try? await notificationService.updateReminderTime(newTime)
                        }
                    }
                }
            } footer: {
                Text(String(localized: "settings.notifications.footer"))
            }
        }
        .navigationTitle(String(localized: "settings.notifications"))
    }

    private func handleToggle(_ enabled: Bool) {
        if enabled {
            Task {
                let granted = try? await notificationService.requestPermission()
                if granted == true {
                    try? await notificationService.scheduleDailyReminder(
                        at: reminderTime,
                        title: String(localized: "notification.reminder.title"),
                        body: String(localized: "notification.reminder.body")
                    )
                } else {
                    isEnabled = false
                }
            }
        } else {
            notificationService.cancelAllReminders()
        }
    }
}

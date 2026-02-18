import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @State private var isEnabled = UserPreferences.shared.notificationsEnabled
    @State private var reminderTime: Date = {
        var components = DateComponents()
        components.hour = UserPreferences.shared.reminderTimeHour
        components.minute = UserPreferences.shared.reminderTimeMinute
        return Calendar.current.date(from: components) ?? OnboardingState.defaultCheckInTime()
    }()
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
                        persistReminderTime(newTime)
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
        .task {
            await checkSystemNotificationStatus()
        }
    }

    private func handleToggle(_ enabled: Bool) {
        UserPreferences.shared.notificationsEnabled = enabled
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
                    UserPreferences.shared.notificationsEnabled = false
                }
            }
        } else {
            notificationService.cancelAllReminders()
        }
    }

    private func persistReminderTime(_ time: Date) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        UserPreferences.shared.reminderTimeHour = components.hour ?? 20
        UserPreferences.shared.reminderTimeMinute = components.minute ?? 0
    }

    private func checkSystemNotificationStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        if settings.authorizationStatus == .denied && isEnabled {
            isEnabled = false
            UserPreferences.shared.notificationsEnabled = false
        }
    }
}

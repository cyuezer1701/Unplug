import Foundation
import UserNotifications

final class NotificationService {
    static let dailyReminderIdentifier = "dailyCheckInReminder"

    func requestPermission() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        return try await center.requestAuthorization(options: [.alert, .badge, .sound])
    }

    func scheduleDailyReminder(at time: Date, title: String, body: String) async throws {
        let center = UNUserNotificationCenter.current()

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: Self.dailyReminderIdentifier,
            content: content,
            trigger: trigger
        )

        try await center.add(request)
    }

    func cancelAllReminders() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [Self.dailyReminderIdentifier])
    }

    func updateReminderTime(_ newTime: Date) async throws {
        cancelAllReminders()
        try await scheduleDailyReminder(
            at: newTime,
            title: String(localized: "notification.reminder.title"),
            body: String(localized: "notification.reminder.body")
        )
    }
}

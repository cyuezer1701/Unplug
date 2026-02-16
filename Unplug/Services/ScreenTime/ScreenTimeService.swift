import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings

final class ScreenTimeService {
    private let store = ManagedSettingsStore()
    private let center = DeviceActivityCenter()

    // MARK: - Authorization

    var isAuthorized: Bool {
        AuthorizationCenter.shared.authorizationStatus == .approved
    }

    func requestAuthorization() async throws -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        return isAuthorized
        #endif
    }

    // MARK: - Monitoring

    func startMonitoring(limitMinutes: Int) throws {
        guard isAuthorized else { return }

        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        // Build event with app filter if user selected specific apps
        let selection = UserPreferences.shared.loadMonitoredAppsSelection()
        let event: DeviceActivityEvent
        if let selection,
           !selection.applicationTokens.isEmpty || !selection.categoryTokens.isEmpty {
            event = DeviceActivityEvent(
                applications: selection.applicationTokens,
                categories: selection.categoryTokens,
                threshold: DateComponents(minute: limitMinutes)
            )
        } else {
            event = DeviceActivityEvent(
                threshold: DateComponents(minute: limitMinutes)
            )
        }

        let eventName = DeviceActivityEvent.Name("scrollLimit")

        // Store limit in App Group for extension access
        UserPreferences.shared.dailyScrollLimitMinutes = limitMinutes

        let activityName = DeviceActivityName("dailyMonitoring")
        try center.startMonitoring(
            activityName,
            during: schedule,
            events: [eventName: event]
        )
    }

    func stopMonitoring() {
        center.stopMonitoring()
        store.clearAllSettings()
    }

    func updateLimit(minutes: Int) throws {
        stopMonitoring()
        try startMonitoring(limitMinutes: minutes)
    }

    func restartMonitoring() throws {
        let limit = UserPreferences.shared.dailyScrollLimitMinutes
        stopMonitoring()
        try startMonitoring(limitMinutes: limit)
    }
}

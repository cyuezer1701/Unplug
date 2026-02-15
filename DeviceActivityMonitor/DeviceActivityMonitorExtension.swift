import DeviceActivity
import Foundation
import ManagedSettings

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let store = ManagedSettingsStore()
    private let defaults = UserDefaults(suiteName: "group.io.unplug.app")

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        defaults?.set(true, forKey: "isMonitoringActive")
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        defaults?.set(false, forKey: "isMonitoringActive")
        store.clearAllSettings()
    }

    override func eventDidReachThreshold(
        _ event: DeviceActivityEvent.Name,
        activity: DeviceActivityName
    ) {
        super.eventDidReachThreshold(event, activity: activity)
        defaults?.set(Date.now.timeIntervalSince1970, forKey: "lastThresholdReached")

        // Shield all apps when scroll limit reached
        store.shield.applications = .all()
    }
}

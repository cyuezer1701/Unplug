import DeviceActivity
import FamilyControls
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

        // Load monitored apps selection from App Group
        if let data = defaults?.data(forKey: "monitoredAppsSelectionData"),
           let selection = try? PropertyListDecoder().decode(
               FamilyActivitySelection.self, from: data
           ) {
            // Shield only the selected apps and categories
            if !selection.applicationTokens.isEmpty {
                store.shield.applications = .specific(selection.applicationTokens)
            }
            if !selection.categoryTokens.isEmpty {
                store.shield.applicationCategories = .specific(selection.categoryTokens)
            }
            if !selection.webDomainTokens.isEmpty {
                store.shield.webDomains = .specific(selection.webDomainTokens)
            }
        } else {
            // Fallback: shield all apps if no specific selection stored
            store.shield.applications = .all()
        }
    }
}

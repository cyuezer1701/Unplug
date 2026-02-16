import Foundation
import Testing
@testable import Unplug

@Suite("UserPreferences Monitored Apps")
struct UserPreferencesMonitoredAppsTests {

    @Test("Monitored apps data defaults to nil when cleared")
    func monitoredAppsDataDefault() {
        let prefs = UserPreferences.shared
        let original = prefs.monitoredAppsSelectionData
        prefs.monitoredAppsSelectionData = nil
        #expect(prefs.monitoredAppsSelectionData == nil)
        prefs.monitoredAppsSelectionData = original
    }

    @Test("Monitored apps data can be written and read")
    func monitoredAppsDataReadWrite() {
        let prefs = UserPreferences.shared
        let original = prefs.monitoredAppsSelectionData
        let testData = Data([0x01, 0x02, 0x03])
        prefs.monitoredAppsSelectionData = testData
        #expect(prefs.monitoredAppsSelectionData == testData)
        prefs.monitoredAppsSelectionData = original
    }

    @Test("hasMonitoredAppsSelection returns false when no data")
    func hasMonitoredAppsSelectionWhenEmpty() {
        let prefs = UserPreferences.shared
        let original = prefs.monitoredAppsSelectionData
        prefs.monitoredAppsSelectionData = nil
        #expect(prefs.hasMonitoredAppsSelection == false)
        prefs.monitoredAppsSelectionData = original
    }

    @Test("hasMonitoredAppsSelection returns false for invalid data")
    func hasMonitoredAppsSelectionWithInvalidData() {
        let prefs = UserPreferences.shared
        let original = prefs.monitoredAppsSelectionData
        prefs.monitoredAppsSelectionData = Data([0xFF, 0xFE])
        #expect(prefs.hasMonitoredAppsSelection == false)
        prefs.monitoredAppsSelectionData = original
    }

    @Test("loadMonitoredAppsSelection returns nil when no data")
    func loadSelectionReturnsNilWhenEmpty() {
        let prefs = UserPreferences.shared
        let original = prefs.monitoredAppsSelectionData
        prefs.monitoredAppsSelectionData = nil
        #expect(prefs.loadMonitoredAppsSelection() == nil)
        prefs.monitoredAppsSelectionData = original
    }
}

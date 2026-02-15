import FirebaseCore
import Foundation

enum FirebaseConfig {
    static var isConfigured = false

    static func configure() {
        guard !isConfigured else { return }
        guard FirebaseApp.app() == nil else {
            isConfigured = true
            return
        }

        // Skip Firebase if GoogleService-Info.plist is missing (e.g. CI)
        guard Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil else {
            return
        }

        FirebaseApp.configure()
        isConfigured = true
    }
}

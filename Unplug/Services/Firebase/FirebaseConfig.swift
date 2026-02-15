import FirebaseCore
import FirebaseFirestore
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

        // Configure Firestore settings once at startup
        let settings = Firestore.firestore().settings
        settings.cacheSettings = PersistentCacheSettings(
            sizeBytes: 100 * 1024 * 1024 as NSNumber
        )
        Firestore.firestore().settings = settings
    }
}

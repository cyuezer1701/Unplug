import FirebaseCore

enum FirebaseConfig {
    static var isConfigured = false

    static func configure() {
        guard !isConfigured else { return }
        guard FirebaseApp.app() == nil else {
            isConfigured = true
            return
        }
        FirebaseApp.configure()
        isConfigured = true
    }
}

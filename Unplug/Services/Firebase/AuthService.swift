import FirebaseAuth
import Foundation

@Observable
final class AuthService {
    private(set) var currentUser: FirebaseAuth.User?
    private var authStateHandle: AuthStateDidChangeListenerHandle?

    var isAuthenticated: Bool {
        currentUser != nil
    }

    var userId: String? {
        currentUser?.uid
    }

    func startListening() {
        guard FirebaseConfig.isConfigured, authStateHandle == nil else { return }
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
        }
    }

    func stopListening() {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
            authStateHandle = nil
        }
    }

    deinit {
        stopListening()
    }

    func signInAnonymously() async throws -> FirebaseAuth.User {
        let result = try await Auth.auth().signInAnonymously()
        return result.user
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}

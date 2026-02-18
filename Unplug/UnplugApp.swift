import SwiftUI

@main
struct UnplugApp: App {
    @State private var appState = AppState()
    @State private var authService = AuthService()

    init() {
        FirebaseConfig.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(authService)
        }
    }
}

struct RootView: View {
    @Environment(AppState.self) private var appState
    @Environment(AuthService.self) private var authService

    var body: some View {
        Group {
            if appState.isLoading {
                LaunchScreenView()
            } else if !appState.hasCompletedOnboarding {
                OnboardingContainerView()
            } else {
                MainTabView()
            }
        }
        .task(id: appState.isLoading) {
            guard appState.isLoading else { return }
            await initializeApp()
        }
    }

    private func initializeApp() async {
        guard FirebaseConfig.isConfigured else {
            // Offline mode (CI or no Firebase)
            if UserPreferences.shared.hasCompletedOnboarding {
                appState.currentUser = UnplugUser(
                    id: UserPreferences.shared.userId ?? UUID().uuidString,
                    onboardingCompleted: true
                )
            }
            appState.isLoading = false
            return
        }

        authService.startListening()
        do {
            let firebaseUser = try await authService.signInAnonymously()
            let userId = firebaseUser.uid
            UserPreferences.shared.userId = userId

            if UserPreferences.shared.hasCompletedOnboarding {
                let firestoreService = FirestoreService()
                if let savedUser = try? await firestoreService.getUser(id: userId) {
                    appState.currentUser = savedUser
                } else {
                    appState.currentUser = UnplugUser(
                        id: userId,
                        onboardingCompleted: true
                    )
                }
            }
            appState.isAuthenticated = true
        } catch {
            // Fallback: work offline with local data
            if UserPreferences.shared.hasCompletedOnboarding {
                appState.currentUser = UnplugUser(
                    id: UserPreferences.shared.userId ?? UUID().uuidString,
                    onboardingCompleted: true
                )
            }
        }
        // Restart Screen Time monitoring if previously authorized
        if UserPreferences.shared.hasCompletedOnboarding {
            let screenTimeService = ScreenTimeService()
            if screenTimeService.isAuthorized {
                try? screenTimeService.startMonitoring(
                    limitMinutes: UserPreferences.shared.dailyScrollLimitMinutes
                )
            }
        }

        appState.isLoading = false
    }
}

struct LaunchScreenView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            UnplugTheme.Colors.primarySage
                .ignoresSafeArea()
            VStack(spacing: UnplugTheme.Spacing.md) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.unplugBounce.repeatForever(autoreverses: true), value: isAnimating)

                Text("Unplug")
                    .font(.unplugTitle())
                    .foregroundStyle(.white)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

import SwiftUI

struct OnboardingContainerView: View {
    @Environment(AppState.self) private var appState
    @State private var onboardingState = OnboardingState()

    var body: some View {
        VStack(spacing: 0) {
            // Progress bar
            ProgressView(value: onboardingState.progress)
                .tint(UnplugTheme.Colors.primarySage)
                .padding(.horizontal, UnplugTheme.Spacing.lg)
                .padding(.top, UnplugTheme.Spacing.sm)
                .animation(.unplugGentle, value: onboardingState.progress)

            // Content
            Group {
                switch onboardingState.currentStep {
                case .welcome:
                    WelcomeView(state: onboardingState)
                case .triggers:
                    TriggerSelectionView(state: onboardingState)
                case .goals:
                    GoalSelectionView(state: onboardingState)
                case .screenTime:
                    ScreenTimePermissionView(state: onboardingState)
                case .appSelection:
                    AppSelectionView(state: onboardingState)
                case .notifications:
                    NotificationSetupView(state: onboardingState) {
                        completeOnboarding()
                    }
                }
            }
            .animation(.unplugSpring, value: onboardingState.currentStep)
            .onChange(of: onboardingState.currentStep) {
                HapticService.impact(.light)
            }
        }
        .unplugBackground()
    }

    private func completeOnboarding() {
        let userId = UserPreferences.shared.userId ?? UUID().uuidString
        let user = UnplugUser(
            id: userId,
            triggers: Array(onboardingState.selectedTriggers),
            goals: onboardingState.selectedGoals,
            dailyCheckInTime: onboardingState.dailyCheckInTime,
            screenTimePermissionGranted: onboardingState.screenTimePermissionGranted,
            notificationsEnabled: onboardingState.notificationsEnabled,
            onboardingCompleted: true
        )
        appState.currentUser = user
        UserPreferences.shared.hasCompletedOnboarding = true
        UserPreferences.shared.userId = userId

        // Start Screen Time monitoring if permission was granted
        if onboardingState.screenTimePermissionGranted {
            let screenTimeService = ScreenTimeService()
            try? screenTimeService.startMonitoring(
                limitMinutes: UserPreferences.shared.dailyScrollLimitMinutes
            )
        }

        // Request notification permission + save to Firestore (fire-and-forget)
        let wantsNotifications = onboardingState.notificationsEnabled
        let checkInTime = onboardingState.dailyCheckInTime
        Task.detached {
            // Notification permission (after view transition completes)
            if wantsNotifications {
                let notificationService = NotificationService()
                let granted = (try? await notificationService.requestPermission()) ?? false
                if granted {
                    try? await notificationService.scheduleDailyReminder(
                        at: checkInTime,
                        title: String(localized: "notification.reminder.title"),
                        body: String(localized: "notification.reminder.body")
                    )
                    UserPreferences.shared.notificationsEnabled = true
                    let components = Calendar.current.dateComponents([.hour, .minute], from: checkInTime)
                    UserPreferences.shared.reminderTimeHour = components.hour ?? 21
                    UserPreferences.shared.reminderTimeMinute = components.minute ?? 0
                }
            }

            // Save user to Firestore
            let firestoreService = FirestoreService()
            try? await firestoreService.createUser(user)
        }
    }
}

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var homeViewModel = HomeViewModel()
    @State private var interventionState = InterventionState()
    @State private var moodSelection: Int = 0
    @State private var showMoodSaved = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: UnplugTheme.Spacing.lg) {
                    // Greeting
                    Text(homeViewModel.greeting)
                        .font(.unplugTitle())
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Today's progress
                    UnplugCard {
                        HStack {
                            VStack(alignment: .leading, spacing: UnplugTheme.Spacing.xs) {
                                Text(String(localized: "home.screentime"))
                                    .font(.unplugCaption())
                                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                                Text("\(homeViewModel.todaySessionCount) \(String(localized: "home.interventions"))")
                                    .font(.unplugHeadline())
                            }
                            Spacer()
                            ProgressRing(progress: homeViewModel.goalProgress, size: 60)
                        }
                    }

                    // Streak
                    UnplugCard {
                        HStack {
                            VStack(alignment: .leading, spacing: UnplugTheme.Spacing.xs) {
                                Text(String(localized: "home.streak"))
                                    .font(.unplugCaption())
                                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                                StreakBadge(
                                    count: homeViewModel.streakCount,
                                    isActive: appState.currentStreak?.isActiveToday ?? false
                                )
                            }
                            Spacer()
                        }
                    }

                    // Mood check-in
                    if let lastMood = homeViewModel.lastMood,
                       Calendar.current.isDateInToday(lastMood.createdAt) {
                        UnplugCard {
                            HStack {
                                Text(String(localized: "home.mood.today"))
                                    .font(.unplugSubheadline())
                                Spacer()
                                Text(lastMood.moodEmoji)
                                    .font(.system(size: 32))
                            }
                        }
                    } else {
                        UnplugCard {
                            VStack(spacing: UnplugTheme.Spacing.md) {
                                Text(String(localized: "home.mood.question"))
                                    .font(.unplugSubheadline())

                                MoodPicker(selectedMood: $moodSelection)

                                if moodSelection > 0 {
                                    UnplugButton(
                                        title: showMoodSaved
                                            ? String(localized: "home.mood.saved")
                                            : String(localized: "home.mood.save"),
                                        isDisabled: showMoodSaved
                                    ) {
                                        saveMood()
                                    }
                                    .transition(.scale.combined(with: .opacity))
                                }
                            }
                        }
                    }

                    // Quick action — Intervention
                    UnplugCard {
                        VStack(alignment: .leading, spacing: UnplugTheme.Spacing.sm) {
                            Text(String(localized: "home.intervention.title"))
                                .font(.unplugSubheadline())
                            Text(String(localized: "home.intervention.subtitle"))
                                .font(.unplugBody())
                                .foregroundStyle(UnplugTheme.Colors.textSecondary)

                            UnplugButton(
                                title: String(localized: "home.intervention.button"),
                                style: .primary
                            ) {
                                interventionState.start()
                            }
                        }
                    }
                }
                .padding(UnplugTheme.Spacing.lg)
            }
            .navigationTitle(String(localized: "tab.home"))
            .unplugBackground()
            .task {
                guard let userId = appState.currentUser?.id else { return }
                let firestoreService = FirestoreService()
                await homeViewModel.loadDashboardData(
                    userId: userId,
                    firestoreService: firestoreService,
                    appState: appState
                )
            }
            .sheet(isPresented: Binding(
                get: { interventionState.isActive },
                set: { if !$0 { interventionState.reset() } }
            )) {
                InterventionFlowView(interventionState: interventionState)
                    .environment(appState)
            }
            .onChange(of: interventionState.isActive) { _, isActive in
                if !isActive { saveSessionIfCompleted() }
            }
        }
    }

    private func saveMood() {
        guard let userId = appState.currentUser?.id else { return }
        Task {
            let firestoreService = FirestoreService()
            try? await homeViewModel.logMood(
                userId: userId,
                moodLevel: moodSelection,
                firestoreService: firestoreService,
                appState: appState
            )
            withAnimation(.unplugSpring) {
                showMoodSaved = true
            }
        }
    }

    private func saveSessionIfCompleted() {
        guard let trigger = interventionState.selectedTrigger,
              interventionState.moodAfter > 0,
              let userId = appState.currentUser?.id else { return }

        let session = ScrollSession(
            userId: userId,
            duration: TimeInterval((interventionState.selectedAlternative?.durationMinutes ?? 5) * 60),
            trigger: trigger,
            interventionShown: true,
            interventionAccepted: true,
            startedAt: interventionState.startedAt ?? .now,
            endedAt: .now
        )

        Task {
            let firestoreService = FirestoreService()
            try? await firestoreService.saveSession(session)
            appState.todaySessions.insert(session, at: 0)

            // Update streak
            if var streak = appState.currentStreak {
                streak.currentCount = StreakCalculator.calculateNewCount(
                    currentCount: streak.currentCount,
                    lastDate: streak.lastDate
                )
                streak.longestCount = StreakCalculator.updateLongest(
                    current: streak.currentCount,
                    longest: streak.longestCount
                )
                streak.lastDate = .now
                appState.currentStreak = streak
                try? await firestoreService.saveStreak(streak)
            } else {
                let newStreak = Streak(
                    userId: userId,
                    type: .checkIn,
                    currentCount: 1,
                    longestCount: 1
                )
                appState.currentStreak = newStreak
                try? await firestoreService.saveStreak(newStreak)
            }
        }
    }
}

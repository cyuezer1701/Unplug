import SwiftUI

struct ChallengeDetailView: View {
    let challenge: Challenge
    @Environment(AppState.self) private var appState
    @State private var isStarting = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.xl) {
            Spacer()

            ProgressRing(progress: challenge.progress, lineWidth: 12, size: 150)
                .overlay {
                    Text("\(Int(challenge.progress * 100))%")
                        .font(.unplugHeadline())
                }

            VStack(spacing: UnplugTheme.Spacing.sm) {
                Text(challenge.title)
                    .font(.unplugHeadline())
                    .multilineTextAlignment(.center)

                Text(challenge.description)
                    .font(.unplugBody())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.lg)
            }

            HStack(spacing: UnplugTheme.Spacing.xl) {
                VStack {
                    Text("\(challenge.durationDays)")
                        .font(.unplugHeadline())
                    Text(String(localized: "challenges.days"))
                        .font(.unplugCaption())
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                }

                if let startDate = challenge.startDate {
                    VStack {
                        Text("\(daysRemaining(from: startDate))")
                            .font(.unplugHeadline())
                        Text(String(localized: "challenges.remaining"))
                            .font(.unplugCaption())
                            .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    }
                }
            }

            Spacer()

            if !challenge.isActive {
                UnplugButton(
                    title: String(localized: "challenges.start"),
                    isLoading: isStarting
                ) {
                    startChallenge()
                }
                .padding(.horizontal, UnplugTheme.Spacing.lg)
            } else if challenge.progress >= 1.0 {
                UnplugButton(
                    title: String(localized: "challenges.completed"),
                    isDisabled: true
                ) {}
                .padding(.horizontal, UnplugTheme.Spacing.lg)
            }
        }
        .padding(.bottom, UnplugTheme.Spacing.xxl)
        .navigationTitle(challenge.title)
        .navigationBarTitleDisplayMode(.inline)
        .unplugBackground()
    }

    private func daysRemaining(from startDate: Date) -> Int {
        let endDate = Calendar.current.date(byAdding: .day, value: challenge.durationDays, to: startDate) ?? startDate
        let remaining = Calendar.current.dateComponents([.day], from: .now, to: endDate).day ?? 0
        return max(0, remaining)
    }

    private func startChallenge() {
        guard let userId = appState.currentUser?.id else { return }
        isStarting = true
        var activeChallenge = challenge
        activeChallenge.isActive = true
        activeChallenge.startDate = .now

        Task {
            let firestoreService = FirestoreService()
            try? await firestoreService.saveChallenge(activeChallenge, userId: userId)
            appState.activeChallenges.append(activeChallenge)
            isStarting = false
            dismiss()
        }
    }
}

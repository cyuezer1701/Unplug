import SwiftUI

struct ChallengeListView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ScrollView {
            VStack(spacing: UnplugTheme.Spacing.lg) {
                if !appState.activeChallenges.isEmpty {
                    VStack(alignment: .leading, spacing: UnplugTheme.Spacing.sm) {
                        Text(String(localized: "challenges.active"))
                            .font(.unplugSubheadline())
                            .padding(.horizontal, UnplugTheme.Spacing.lg)

                        ForEach(appState.activeChallenges) { challenge in
                            NavigationLink {
                                ChallengeDetailView(challenge: challenge)
                            } label: {
                                activeChallengeCard(challenge)
                            }
                            .padding(.horizontal, UnplugTheme.Spacing.lg)
                        }
                    }
                }

                VStack(alignment: .leading, spacing: UnplugTheme.Spacing.sm) {
                    Text(String(localized: "challenges.available"))
                        .font(.unplugSubheadline())
                        .padding(.horizontal, UnplugTheme.Spacing.lg)

                    ForEach(availableChallenges) { challenge in
                        NavigationLink {
                            ChallengeDetailView(challenge: challenge)
                        } label: {
                            availableChallengeCard(challenge)
                        }
                        .padding(.horizontal, UnplugTheme.Spacing.lg)
                    }
                }
            }
            .padding(.vertical, UnplugTheme.Spacing.lg)
        }
        .navigationTitle(String(localized: "challenges.title"))
        .unplugBackground()
    }

    private var availableChallenges: [Challenge] {
        let activeIds = Set(appState.activeChallenges.compactMap(\.id))
        return ChallengeManager.presetChallenges(userId: appState.currentUser?.id ?? "")
            .filter { !activeIds.contains($0.id ?? "") }
    }

    @ViewBuilder
    private func activeChallengeCard(_ challenge: Challenge) -> some View {
        UnplugCard {
            HStack {
                VStack(alignment: .leading, spacing: UnplugTheme.Spacing.xs) {
                    Text(challenge.title)
                        .font(.unplugCallout())
                        .foregroundStyle(UnplugTheme.Colors.textPrimary)
                    Text("\(Int(challenge.progress * 100))%")
                        .font(.unplugCaption())
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                }
                Spacer()
                ProgressRing(progress: challenge.progress, lineWidth: 6, size: 50)
            }
        }
    }

    @ViewBuilder
    private func availableChallengeCard(_ challenge: Challenge) -> some View {
        UnplugCard {
            VStack(alignment: .leading, spacing: UnplugTheme.Spacing.xs) {
                Text(challenge.title)
                    .font(.unplugCallout())
                    .foregroundStyle(UnplugTheme.Colors.textPrimary)
                Text(challenge.description)
                    .font(.unplugCaption())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .lineLimit(2)
                HStack {
                    Label("\(challenge.durationDays) \(String(localized: "challenges.days"))", systemImage: "calendar")
                        .font(.unplugCaption())
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                }
            }
        }
    }
}

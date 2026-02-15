import SwiftUI

struct InsightsView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = InsightsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, UnplugTheme.Spacing.xxxl)
                } else if !viewModel.hasData {
                    emptyState
                } else {
                    insightsContent
                }
            }
            .navigationTitle(String(localized: "tab.insights"))
            .unplugBackground()
            .task {
                guard let userId = appState.currentUser?.id else { return }
                let firestoreService = FirestoreService()
                await viewModel.loadInsights(userId: userId, firestoreService: firestoreService)
            }
        }
    }

    private var insightsContent: some View {
        VStack(spacing: UnplugTheme.Spacing.lg) {
            // Stats row
            HStack(spacing: UnplugTheme.Spacing.sm) {
                StatCard(
                    title: String(localized: "insights.interventions"),
                    value: "\(viewModel.weeklySessionCount)",
                    icon: "hand.raised.fill"
                )
                StatCard(
                    title: String(localized: "insights.saved"),
                    value: "\(viewModel.totalMinutesSaved)m",
                    icon: "clock.fill",
                    color: UnplugTheme.Colors.success
                )
                StatCard(
                    title: String(localized: "insights.mood"),
                    value: String(format: "%.1f", viewModel.averageMood),
                    icon: "face.smiling.fill",
                    color: UnplugTheme.Colors.accentCoral
                )
            }

            // Mood trend
            if !viewModel.moodTrend.isEmpty {
                UnplugCard {
                    VStack(alignment: .leading, spacing: UnplugTheme.Spacing.md) {
                        Text(String(localized: "insights.mood.trend"))
                            .font(.unplugSubheadline())
                        MoodTrendChart(data: viewModel.moodTrend)
                    }
                }
            }

            // Trigger frequency
            if !viewModel.triggerFrequency.isEmpty {
                UnplugCard {
                    VStack(alignment: .leading, spacing: UnplugTheme.Spacing.md) {
                        Text(String(localized: "insights.triggers"))
                            .font(.unplugSubheadline())
                        TriggerFrequencyChart(data: viewModel.triggerFrequency)
                    }
                }
            }
        }
        .padding(UnplugTheme.Spacing.lg)
    }

    private var emptyState: some View {
        VStack(spacing: UnplugTheme.Spacing.lg) {
            Spacer()

            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60))
                .foregroundStyle(UnplugTheme.Colors.primarySage.opacity(0.3))

            Text(String(localized: "insights.empty.title"))
                .font(.unplugBody())
                .foregroundStyle(UnplugTheme.Colors.textSecondary)

            Text(String(localized: "insights.empty.subtitle"))
                .font(.unplugCaption())
                .foregroundStyle(UnplugTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, UnplugTheme.Spacing.xxl)

            Spacer()
        }
    }
}

import SwiftUI

struct InsightsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: UnplugTheme.Spacing.lg) {
                Spacer()

                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(UnplugTheme.Colors.primarySage.opacity(0.3))

                Text("Your insights will appear here")
                    .font(.unplugBody())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)

                Text("Start tracking to see your screen time trends, mood patterns, and progress.")
                    .font(.unplugCaption())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.xxl)

                Spacer()
            }
            .navigationTitle("Insights")
            .unplugBackground()
        }
    }
}

import SwiftUI

struct AlternativeListView: View {
    let state: InterventionState
    @State private var alternatives: [Alternative] = []
    @State private var weather: WeatherCondition?

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.lg) {
            VStack(spacing: UnplugTheme.Spacing.sm) {
                if let trigger = state.selectedTrigger {
                    Text(trigger.emoji)
                        .font(.system(size: 36))

                    Text(String(localized: "intervention.alternatives.title"))
                        .font(.unplugHeadline())

                    Text(String(localized: "intervention.alternatives.subtitle"))
                        .font(.unplugBody())
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, UnplugTheme.Spacing.md)
                }
            }
            .padding(.top, UnplugTheme.Spacing.lg)

            ScrollView {
                VStack(spacing: UnplugTheme.Spacing.sm) {
                    ForEach(alternatives) { alternative in
                        AlternativeCard(alternative: alternative) {
                            HapticService.selection()
                            withAnimation(.unplugSpring) {
                                state.selectAlternative(alternative)
                                state.advance()
                            }
                        }
                    }
                }
                .padding(.horizontal, UnplugTheme.Spacing.lg)
            }

            Spacer()

            Button {
                withAnimation(.unplugSpring) {
                    state.goBack()
                }
            } label: {
                Text(String(localized: "intervention.back"))
                    .font(.unplugCallout())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
            }
            .padding(.bottom, UnplugTheme.Spacing.xl)
        }
        .task {
            let contextService = ContextService()
            weather = await contextService.getCurrentWeather()
            if let trigger = state.selectedTrigger {
                alternatives = AlternativeSuggester.suggest(trigger: trigger, weather: weather)
            }
        }
    }
}

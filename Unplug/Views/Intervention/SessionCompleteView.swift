import SwiftUI

struct SessionCompleteView: View {
    let state: InterventionState
    @State private var showConfetti = false

    var body: some View {
        ScrollView {
            VStack(spacing: UnplugTheme.Spacing.xl) {
                // Celebration
                VStack(spacing: UnplugTheme.Spacing.sm) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(UnplugTheme.Colors.accentCoral)
                        .scaleEffect(showConfetti ? 1.2 : 0.8)
                        .animation(.unplugBounce, value: showConfetti)

                    Text(String(localized: "intervention.complete.title"))
                        .font(.unplugHeadline())

                    Text(String(localized: "intervention.complete.subtitle"))
                        .font(.unplugBody())
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, UnplugTheme.Spacing.md)
                }
                .padding(.top, UnplugTheme.Spacing.xl)

                // Mood picker
                UnplugCard {
                    VStack(spacing: UnplugTheme.Spacing.md) {
                        Text(String(localized: "intervention.complete.mood"))
                            .font(.unplugSubheadline())

                        MoodPicker(selectedMood: Binding(
                            get: { state.moodAfter },
                            set: { state.moodAfter = $0 }
                        ))
                    }
                }
                .padding(.horizontal, UnplugTheme.Spacing.lg)

                // Notes
                UnplugCard {
                    VStack(alignment: .leading, spacing: UnplugTheme.Spacing.sm) {
                        Text(String(localized: "intervention.complete.notes"))
                            .font(.unplugSubheadline())

                        TextField(
                            String(localized: "intervention.complete.notes.placeholder"),
                            text: Binding(
                                get: { state.notes },
                                set: { state.notes = $0 }
                            ),
                            axis: .vertical
                        )
                        .lineLimit(3...6)
                        .font(.unplugBody())
                        .textFieldStyle(.plain)
                    }
                }
                .padding(.horizontal, UnplugTheme.Spacing.lg)

                // Save button
                UnplugButton(
                    title: String(localized: "intervention.complete.save"),
                    isDisabled: state.moodAfter == 0
                ) {
                    HapticService.notification(.success)
                    withAnimation(.unplugSpring) {
                        state.complete()
                    }
                }
                .padding(.horizontal, UnplugTheme.Spacing.lg)
                .padding(.bottom, UnplugTheme.Spacing.xxl)
            }
        }
        .onAppear {
            HapticService.notification(.success)
            withAnimation(.unplugBounce.delay(0.2)) {
                showConfetti = true
            }
        }
    }
}

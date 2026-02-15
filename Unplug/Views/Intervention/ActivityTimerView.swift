import SwiftUI

struct ActivityTimerView: View {
    let state: InterventionState
    @State private var elapsedSeconds: Int = 0
    @State private var isTimerRunning = true
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.xl) {
            Spacer()

            if let alternative = state.selectedAlternative {
                Image(systemName: categoryIcon(alternative.category))
                    .font(.system(size: 50))
                    .foregroundStyle(UnplugTheme.Colors.primarySage)
                    .symbolEffect(.pulse, isActive: isTimerRunning)

                Text(alternative.title)
                    .font(.unplugHeadline())

                Text(alternative.description)
                    .font(.unplugBody())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.xl)

                // Timer display
                Text(timerText)
                    .font(.system(size: 48, weight: .light, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(UnplugTheme.Colors.primarySage)
                    .padding(.top, UnplugTheme.Spacing.lg)

                Text(String(localized: "intervention.activity.encouragement"))
                    .font(.unplugCaption())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
            }

            Spacer()

            UnplugButton(title: String(localized: "intervention.activity.done")) {
                stopTimer()
                withAnimation(.unplugSpring) {
                    state.advance()
                }
            }
            .padding(.horizontal, UnplugTheme.Spacing.lg)

            Button {
                stopTimer()
                withAnimation(.unplugSpring) {
                    state.goBack()
                }
            } label: {
                Text(String(localized: "intervention.activity.different"))
                    .font(.unplugCallout())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
            }
            .padding(.bottom, UnplugTheme.Spacing.xxl)
        }
        .onAppear { startTimer() }
        .onDisappear { stopTimer() }
    }

    private var timerText: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedSeconds += 1
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }

    private func categoryIcon(_ category: AlternativeCategory) -> String {
        switch category {
        case .movement: return "figure.walk"
        case .mindfulness: return "brain.head.profile"
        case .creative: return "paintpalette.fill"
        case .social: return "person.2.fill"
        case .learning: return "book.fill"
        case .outdoor: return "sun.max.fill"
        case .selfCare: return "heart.fill"
        }
    }
}

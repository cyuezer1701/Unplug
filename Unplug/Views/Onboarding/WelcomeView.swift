import SwiftUI

struct WelcomeView: View {
    let state: OnboardingState

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.xl) {
            Spacer()

            Image(systemName: "leaf.circle.fill")
                .font(.system(size: 100))
                .foregroundStyle(UnplugTheme.Colors.primarySage)
                .symbolEffect(.pulse, options: .repeating)

            VStack(spacing: UnplugTheme.Spacing.md) {
                Text(String(localized: "onboarding.welcome.title"))
                    .font(.unplugTitle())
                    .multilineTextAlignment(.center)

                Text(String(localized: "onboarding.welcome.description"))
                    .font(.unplugBody())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.lg)
            }

            Spacer()

            UnplugButton(title: String(localized: "onboarding.welcome.button")) {
                state.advance()
            }
            .padding(.horizontal, UnplugTheme.Spacing.lg)
            .padding(.bottom, UnplugTheme.Spacing.xxl)
        }
    }
}

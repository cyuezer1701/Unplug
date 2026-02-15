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
                Text("Take back your time")
                    .font(.unplugTitle())
                    .multilineTextAlignment(.center)

                Text("Unplug helps you break doom-scrolling habits with smart, context-aware alternatives that actually feel better than the screen.")
                    .font(.unplugBody())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.lg)
            }

            Spacer()

            UnplugButton(title: "Get Started") {
                state.advance()
            }
            .padding(.horizontal, UnplugTheme.Spacing.lg)
            .padding(.bottom, UnplugTheme.Spacing.xxl)
        }
    }
}

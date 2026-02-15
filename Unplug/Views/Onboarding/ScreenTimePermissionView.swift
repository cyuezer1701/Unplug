import SwiftUI

struct ScreenTimePermissionView: View {
    let state: OnboardingState

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.xl) {
            Spacer()

            Image(systemName: "hourglass.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(UnplugTheme.Colors.primarySage)

            VStack(spacing: UnplugTheme.Spacing.md) {
                Text("Screen Time Access")
                    .font(.unplugHeadline())
                    .multilineTextAlignment(.center)

                Text("To detect when you're doom-scrolling, Unplug needs access to your Screen Time data. This stays on your device.")
                    .font(.unplugBody())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.lg)
            }

            // Privacy callout
            HStack(spacing: UnplugTheme.Spacing.sm) {
                Image(systemName: "lock.shield.fill")
                    .foregroundStyle(UnplugTheme.Colors.primarySage)
                Text("Your data never leaves your device. We can't see which apps you use.")
                    .font(.unplugCaption())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
            }
            .padding(UnplugTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: UnplugTheme.Radius.md)
                    .fill(UnplugTheme.Colors.surfaceCard)
            )
            .padding(.horizontal, UnplugTheme.Spacing.lg)

            Spacer()

            VStack(spacing: UnplugTheme.Spacing.sm) {
                UnplugButton(title: "Allow Screen Time Access") {
                    // Phase 2: Actual FamilyControls authorization
                    state.screenTimePermissionGranted = true
                    state.advance()
                }

                Button {
                    state.advance()
                } label: {
                    Text("Skip for now")
                        .font(.unplugCallout())
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                }
            }
            .padding(.horizontal, UnplugTheme.Spacing.lg)
            .padding(.bottom, UnplugTheme.Spacing.xxl)
        }
    }
}

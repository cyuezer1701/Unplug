import SwiftUI

struct ScreenTimePermissionView: View {
    let state: OnboardingState
    @State private var isRequesting = false
    private let screenTimeService = ScreenTimeService()

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.xl) {
            Spacer()

            Image(systemName: "hourglass.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(UnplugTheme.Colors.primarySage)

            VStack(spacing: UnplugTheme.Spacing.md) {
                Text(String(localized: "onboarding.screentime.title"))
                    .font(.unplugHeadline())
                    .multilineTextAlignment(.center)

                Text(String(localized: "onboarding.screentime.description"))
                    .font(.unplugBody())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.lg)
            }

            HStack(spacing: UnplugTheme.Spacing.sm) {
                Image(systemName: "lock.shield.fill")
                    .foregroundStyle(UnplugTheme.Colors.primarySage)
                Text(String(localized: "onboarding.screentime.privacy"))
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
                UnplugButton(
                    title: String(localized: "onboarding.screentime.allow"),
                    isLoading: isRequesting
                ) {
                    requestAccess()
                }

                Button {
                    state.advance()
                } label: {
                    Text(String(localized: "onboarding.screentime.skip"))
                        .font(.unplugCallout())
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                }
            }
            .padding(.horizontal, UnplugTheme.Spacing.lg)
            .padding(.bottom, UnplugTheme.Spacing.xxl)
        }
    }

    private func requestAccess() {
        isRequesting = true
        Task {
            let granted = (try? await screenTimeService.requestAuthorization()) ?? false
            state.screenTimePermissionGranted = granted
            isRequesting = false
            state.advance()
        }
    }
}

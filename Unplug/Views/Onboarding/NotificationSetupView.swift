import SwiftUI

struct NotificationSetupView: View {
    let state: OnboardingState
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.xl) {
            Spacer()

            Image(systemName: "bell.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(UnplugTheme.Colors.accentCoral)

            VStack(spacing: UnplugTheme.Spacing.md) {
                Text(String(localized: "onboarding.notifications.title"))
                    .font(.unplugHeadline())
                    .multilineTextAlignment(.center)

                Text(String(localized: "onboarding.notifications.description"))
                    .font(.unplugBody())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.lg)
            }

            // Check-in time picker
            VStack(spacing: UnplugTheme.Spacing.sm) {
                Text(String(localized: "onboarding.notifications.time"))
                    .font(.unplugSubheadline())

                DatePicker(
                    "",
                    selection: Binding(
                        get: { state.dailyCheckInTime },
                        set: { state.dailyCheckInTime = $0 }
                    ),
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(height: 120)
            }

            Spacer()

            VStack(spacing: UnplugTheme.Spacing.sm) {
                UnplugButton(title: String(localized: "onboarding.notifications.enable")) {
                    state.notificationsEnabled = true
                    onComplete()
                }

                Button {
                    onComplete()
                } label: {
                    Text(String(localized: "onboarding.notifications.skip"))
                        .font(.unplugCallout())
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                }
            }
            .padding(.horizontal, UnplugTheme.Spacing.lg)
            .padding(.bottom, UnplugTheme.Spacing.xxl)
        }
    }
}

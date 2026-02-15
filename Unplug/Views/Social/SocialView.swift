import SwiftUI

struct SocialView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: UnplugTheme.Spacing.lg) {
                Spacer()

                Image(systemName: "person.2.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(UnplugTheme.Colors.primarySage.opacity(0.3))

                Text("Find your accountability buddy")
                    .font(.unplugSubheadline())
                    .foregroundStyle(UnplugTheme.Colors.textPrimary)

                Text("Connect with a friend to share progress and keep each other motivated.")
                    .font(.unplugCaption())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UnplugTheme.Spacing.xxl)

                UnplugButton(title: "Invite a buddy") {
                    // Phase 2: Buddy invite flow
                }
                .padding(.horizontal, UnplugTheme.Spacing.xxl)

                Spacer()
            }
            .navigationTitle("Social")
            .unplugBackground()
        }
    }
}

import SwiftUI

struct InviteBuddyView: View {
    @Environment(AppState.self) private var appState
    let viewModel: SocialViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: UnplugTheme.Spacing.xl) {
            // Generate invite code section
            VStack(spacing: UnplugTheme.Spacing.md) {
                Text(String(localized: "social.invite.share"))
                    .font(.unplugSubheadline())

                if let code = viewModel.inviteCode {
                    Text(code)
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .foregroundStyle(UnplugTheme.Colors.primarySage)
                        .padding(UnplugTheme.Spacing.lg)
                        .background(
                            RoundedRectangle(cornerRadius: UnplugTheme.Radius.lg)
                                .fill(UnplugTheme.Colors.surfaceCard)
                        )

                    ShareLink(item: String(localized: "social.invite.message \(code)")) {
                        Label(String(localized: "social.invite.shareButton"), systemImage: "square.and.arrow.up")
                            .font(.unplugCallout())
                            .foregroundStyle(UnplugTheme.Colors.primarySage)
                    }
                } else {
                    UnplugButton(
                        title: String(localized: "social.invite.generate"),
                        isLoading: viewModel.isGeneratingCode
                    ) {
                        Task {
                            guard let userId = appState.currentUser?.id else { return }
                            await viewModel.generateCode(userId: userId)
                        }
                    }
                }
            }
            .padding(UnplugTheme.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: UnplugTheme.Radius.lg)
                    .fill(UnplugTheme.Colors.surfaceCard)
            )

            // Divider
            HStack {
                Rectangle()
                    .fill(UnplugTheme.Colors.textSecondary.opacity(0.2))
                    .frame(height: 1)
                Text(String(localized: "social.invite.or"))
                    .font(.unplugCaption())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
                Rectangle()
                    .fill(UnplugTheme.Colors.textSecondary.opacity(0.2))
                    .frame(height: 1)
            }

            // Enter code section
            VStack(spacing: UnplugTheme.Spacing.md) {
                Text(String(localized: "social.invite.enter"))
                    .font(.unplugSubheadline())

                TextField(String(localized: "social.invite.placeholder"), text: Binding(
                    get: { viewModel.enteredCode },
                    set: { viewModel.enteredCode = $0.uppercased() }
                ))
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .multilineTextAlignment(.center)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .padding(UnplugTheme.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: UnplugTheme.Radius.md)
                        .fill(UnplugTheme.Colors.surfaceCard)
                )

                UnplugButton(
                    title: String(localized: "social.invite.connect"),
                    isDisabled: viewModel.enteredCode.count < 6,
                    isLoading: viewModel.isConnecting
                ) {
                    Task {
                        guard let userId = appState.currentUser?.id else { return }
                        let success = await viewModel.connectWithCode(userId: userId)
                        if success { dismiss() }
                    }
                }
            }
            .padding(UnplugTheme.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: UnplugTheme.Radius.lg)
                    .fill(UnplugTheme.Colors.surfaceCard)
            )

            Spacer()
        }
        .padding(UnplugTheme.Spacing.lg)
        .navigationTitle(String(localized: "social.invite.title"))
        .alert(String(localized: "social.error.title"), isPresented: Binding(
            get: { viewModel.showError },
            set: { viewModel.showError = $0 }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

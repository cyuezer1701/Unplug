import SwiftUI

struct SocialView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = SocialViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.buddies.isEmpty {
                    emptyState
                } else {
                    buddyList
                }
            }
            .navigationTitle(String(localized: "tab.social"))
            .unplugBackground()
            .task {
                guard let userId = appState.currentUser?.id else { return }
                await viewModel.loadBuddies(userId: userId)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: UnplugTheme.Spacing.lg) {
            Spacer()

            Image(systemName: "person.2.fill")
                .font(.system(size: 60))
                .foregroundStyle(UnplugTheme.Colors.primarySage.opacity(0.3))

            Text(String(localized: "social.empty.title"))
                .font(.unplugSubheadline())
                .foregroundStyle(UnplugTheme.Colors.textPrimary)

            Text(String(localized: "social.empty.description"))
                .font(.unplugCaption())
                .foregroundStyle(UnplugTheme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, UnplugTheme.Spacing.xxl)

            NavigationLink {
                InviteBuddyView(viewModel: viewModel)
            } label: {
                Text(String(localized: "social.invite.button"))
                    .font(.unplugCallout())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, UnplugTheme.Spacing.md)
                    .background(UnplugTheme.Colors.primarySage)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: UnplugTheme.Radius.lg))
            }
            .padding(.horizontal, UnplugTheme.Spacing.xxl)

            Spacer()
        }
    }

    private var buddyList: some View {
        ScrollView {
            VStack(spacing: UnplugTheme.Spacing.md) {
                ForEach(viewModel.buddies) { buddy in
                    BuddyCardView(
                        buddy: buddy,
                        progress: viewModel.buddyProgress[buddy.userId]
                    )
                }
            }
            .padding(UnplugTheme.Spacing.lg)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    InviteBuddyView(viewModel: viewModel)
                } label: {
                    Image(systemName: "person.badge.plus")
                }
            }
        }
    }
}

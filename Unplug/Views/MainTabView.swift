import SwiftUI

struct MainTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var state = appState

        TabView(selection: $state.selectedTab) {
            HomeView()
                .tabItem {
                    Label(AppTab.home.title, systemImage: AppTab.home.iconName)
                }
                .tag(AppTab.home)

            InsightsView()
                .tabItem {
                    Label(AppTab.insights.title, systemImage: AppTab.insights.iconName)
                }
                .tag(AppTab.insights)

            SocialView()
                .tabItem {
                    Label(AppTab.social.title, systemImage: AppTab.social.iconName)
                }
                .tag(AppTab.social)

            SettingsView()
                .tabItem {
                    Label(AppTab.settings.title, systemImage: AppTab.settings.iconName)
                }
                .tag(AppTab.settings)
        }
        .tint(UnplugTheme.Colors.primarySage)
    }
}

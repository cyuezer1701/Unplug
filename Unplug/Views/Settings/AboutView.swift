import SwiftUI

struct AboutView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        List {
            Section(String(localized: "about.version.section")) {
                HStack {
                    Text(String(localized: "about.version"))
                    Spacer()
                    Text(appVersion)
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                }

                HStack {
                    Text(String(localized: "about.build"))
                    Spacer()
                    Text(buildNumber)
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                }
            }

            Section(String(localized: "about.legal.section")) {
                Link(destination: URL(string: "https://unplug.io/privacy")!) {
                    HStack {
                        Text(String(localized: "about.privacy"))
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .font(.caption)
                            .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    }
                }

                Link(destination: URL(string: "https://unplug.io/terms")!) {
                    HStack {
                        Text(String(localized: "about.terms"))
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .font(.caption)
                            .foregroundStyle(UnplugTheme.Colors.textSecondary)
                    }
                }
            }

            Section {
                VStack(spacing: UnplugTheme.Spacing.sm) {
                    Image(systemName: "leaf.fill")
                        .font(.largeTitle)
                        .foregroundStyle(UnplugTheme.Colors.primarySage)

                    Text(String(localized: "about.tagline"))
                        .font(.unplugSubheadline())
                        .foregroundStyle(UnplugTheme.Colors.textPrimary)

                    Text(String(localized: "about.madeWith"))
                        .font(.unplugCaption())
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, UnplugTheme.Spacing.lg)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle(String(localized: "about.title"))
    }
}

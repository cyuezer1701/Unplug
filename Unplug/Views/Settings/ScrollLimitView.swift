import SwiftUI

struct ScrollLimitView: View {
    let viewModel: SettingsViewModel
    private let options = [15, 30, 45, 60, 90, 120]

    var body: some View {
        List {
            Section {
                ForEach(options, id: \.self) { minutes in
                    Button {
                        viewModel.updateScrollLimit(minutes)
                    } label: {
                        HStack {
                            Text("\(minutes) \(String(localized: "settings.scrolllimit.minutes"))")
                                .font(.unplugBody())
                                .foregroundStyle(UnplugTheme.Colors.textPrimary)
                            Spacer()
                            if viewModel.scrollLimitMinutes == minutes {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(UnplugTheme.Colors.primarySage)
                            }
                        }
                    }
                }
            } header: {
                Text(String(localized: "settings.scrolllimit.header"))
            } footer: {
                Text(String(localized: "settings.scrolllimit.footer"))
            }
        }
        .navigationTitle(String(localized: "settings.scrolllimit"))
    }
}

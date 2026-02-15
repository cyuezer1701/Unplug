import SwiftUI

struct UnplugCard<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(UnplugTheme.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: UnplugTheme.Radius.lg)
                    .fill(UnplugTheme.Colors.surfaceCard)
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
            )
    }
}

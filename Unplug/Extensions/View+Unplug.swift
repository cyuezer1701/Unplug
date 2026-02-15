import SwiftUI

extension View {
    func unplugCard() -> some View {
        self
            .padding(UnplugTheme.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: UnplugTheme.Radius.lg)
                    .fill(UnplugTheme.Colors.surfaceCard)
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
            )
    }

    func unplugBackground() -> some View {
        self.background(UnplugTheme.Colors.background.ignoresSafeArea())
    }
}

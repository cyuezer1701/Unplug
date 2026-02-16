import SwiftUI

struct ErrorBanner: View {
    let message: String
    let onRetry: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: UnplugTheme.Spacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(UnplugTheme.Colors.warning)

            Text(message)
                .font(.unplugCaption())
                .foregroundStyle(UnplugTheme.Colors.textPrimary)
                .lineLimit(2)

            Spacer()

            Button {
                onRetry()
            } label: {
                Text(String(localized: "error.retry"))
                    .font(.unplugCaption())
                    .fontWeight(.semibold)
                    .foregroundStyle(UnplugTheme.Colors.primarySage)
            }

            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.caption2)
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
            }
        }
        .padding(UnplugTheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: UnplugTheme.Radius.md)
                .fill(UnplugTheme.Colors.surfaceCard)
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        )
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

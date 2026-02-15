import SwiftUI

enum UnplugButtonStyle {
    case primary
    case secondary
    case destructive
}

struct UnplugButton: View {
    let title: String
    var style: UnplugButtonStyle = .primary
    var isDisabled: Bool = false
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: UnplugTheme.Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                }
                Text(title)
                    .font(.unplugCallout())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, UnplugTheme.Spacing.md)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: UnplugTheme.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: UnplugTheme.Radius.lg)
                    .strokeBorder(borderColor, lineWidth: style == .secondary ? 1.5 : 0)
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1.0)
        .accessibilityLabel(title)
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return UnplugTheme.Colors.primarySage
        case .secondary: return .clear
        case .destructive: return UnplugTheme.Colors.accentCoral
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary: return UnplugTheme.Colors.primarySage
        case .destructive: return .white
        }
    }

    private var borderColor: Color {
        switch style {
        case .secondary: return UnplugTheme.Colors.primarySage
        default: return .clear
        }
    }
}

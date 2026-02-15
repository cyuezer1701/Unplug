import SwiftUI

struct AlternativeCard: View {
    let alternative: Alternative
    var onSelect: (() -> Void)?

    var body: some View {
        Button {
            onSelect?()
        } label: {
            HStack(spacing: UnplugTheme.Spacing.md) {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundStyle(UnplugTheme.Colors.primarySage)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(UnplugTheme.Colors.primarySage.opacity(0.15))
                    )

                VStack(alignment: .leading, spacing: UnplugTheme.Spacing.xxs) {
                    Text(alternative.title)
                        .font(.unplugSubheadline())
                        .foregroundStyle(UnplugTheme.Colors.textPrimary)

                    Text(alternative.description)
                        .font(.unplugCaption())
                        .foregroundStyle(UnplugTheme.Colors.textSecondary)
                        .lineLimit(2)

                    Text("\(alternative.durationMinutes) min")
                        .font(.unplugCaption())
                        .foregroundStyle(UnplugTheme.Colors.primarySage)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
            }
            .padding(UnplugTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: UnplugTheme.Radius.md)
                    .fill(UnplugTheme.Colors.surfaceCard)
                    .shadow(color: .black.opacity(0.03), radius: 2, y: 1)
            )
        }
        .accessibilityLabel("\(alternative.title), \(alternative.durationMinutes) minutes")
    }

    private var iconName: String {
        switch alternative.category {
        case .movement: return "figure.walk"
        case .mindfulness: return "brain.head.profile"
        case .creative: return "paintpalette.fill"
        case .social: return "person.2.fill"
        case .learning: return "book.fill"
        case .outdoor: return "sun.max.fill"
        case .selfCare: return "heart.fill"
        }
    }
}

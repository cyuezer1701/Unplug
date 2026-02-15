import SwiftUI

extension Font {
    static func unplugTitle() -> Font {
        .system(.largeTitle, design: .rounded, weight: .bold)
    }

    static func unplugHeadline() -> Font {
        .system(.title2, design: .rounded, weight: .semibold)
    }

    static func unplugSubheadline() -> Font {
        .system(.headline, design: .rounded, weight: .medium)
    }

    static func unplugBody() -> Font {
        .system(.body, design: .rounded)
    }

    static func unplugCaption() -> Font {
        .system(.caption, design: .rounded)
    }

    static func unplugCallout() -> Font {
        .system(.callout, design: .rounded, weight: .medium)
    }
}

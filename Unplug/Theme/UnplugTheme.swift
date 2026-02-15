import SwiftUI

enum UnplugTheme {
    // MARK: - Colors

    enum Colors {
        static let primarySage = Color("Colors/PrimarySage")
        static let accentCoral = Color("Colors/AccentCoral")
        static let backgroundLight = Color("Colors/BackgroundLight")
        static let backgroundDark = Color("Colors/BackgroundDark")
        static let textPrimary = Color("Colors/TextPrimary")
        static let textSecondary = Color("Colors/TextSecondary")
        static let surfaceCard = Color("Colors/SurfaceCard")
        static let success = Color("Colors/Success")
        static let warning = Color("Colors/Warning")

        static var background: Color {
            Color("Colors/BackgroundLight")
        }
    }

    // MARK: - Spacing

    enum Spacing {
        static let xxxs: CGFloat = 2
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }

    // MARK: - Corner Radius

    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let full: CGFloat = 9999
    }

    // MARK: - Shadows

    enum Shadow {
        static let sm: CGFloat = 2
        static let md: CGFloat = 4
        static let lg: CGFloat = 8
    }
}

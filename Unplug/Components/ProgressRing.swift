import SwiftUI

struct ProgressRing: View {
    let progress: Double
    var lineWidth: CGFloat = 8
    var size: CGFloat = 80
    var primaryColor: Color = UnplugTheme.Colors.primarySage
    var trackColor: Color = UnplugTheme.Colors.surfaceCard

    var body: some View {
        ZStack {
            Circle()
                .stroke(trackColor, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    primaryColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.unplugSpring, value: progress)
        }
        .frame(width: size, height: size)
        .accessibilityValue("\(Int(progress * 100)) percent")
    }
}

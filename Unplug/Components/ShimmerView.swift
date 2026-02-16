import SwiftUI

struct ShimmerView: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        Rectangle()
            .fill(UnplugTheme.Colors.surfaceCard)
            .overlay(
                LinearGradient(
                    colors: [
                        .clear,
                        UnplugTheme.Colors.textSecondary.opacity(0.08),
                        .clear,
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
            )
            .clipped()
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = UIScreen.main.bounds.width
                }
            }
    }
}

struct SkeletonCard: View {
    var height: CGFloat = 80

    var body: some View {
        ShimmerView()
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: UnplugTheme.Radius.lg))
    }
}

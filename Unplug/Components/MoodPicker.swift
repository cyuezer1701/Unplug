import SwiftUI

struct MoodPicker: View {
    @Binding var selectedMood: Int

    private let moods: [(level: Int, emoji: String, label: String)] = [
        (1, "😢", "Awful"),
        (2, "😕", "Bad"),
        (3, "😐", "Okay"),
        (4, "😊", "Good"),
        (5, "😄", "Great"),
    ]

    var body: some View {
        HStack(spacing: UnplugTheme.Spacing.md) {
            ForEach(moods, id: \.level) { mood in
                Button {
                    HapticService.selection()
                    withAnimation(.unplugSpring) {
                        selectedMood = mood.level
                    }
                } label: {
                    VStack(spacing: UnplugTheme.Spacing.xxs) {
                        Text(mood.emoji)
                            .font(.system(size: selectedMood == mood.level ? 36 : 28))

                        if selectedMood == mood.level {
                            Text(mood.label)
                                .font(.unplugCaption())
                                .foregroundStyle(UnplugTheme.Colors.textSecondary)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .accessibilityLabel("\(mood.label), mood level \(mood.level)")
                .accessibilityAddTraits(selectedMood == mood.level ? .isSelected : [])
            }
        }
    }
}

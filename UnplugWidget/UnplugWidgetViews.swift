import SwiftUI
import WidgetKit

struct UnplugWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: UnplugWidgetEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Small Widget

private struct SmallWidgetView: View {
    let entry: UnplugWidgetEntry

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "flame.fill")
                .font(.system(size: 36))
                .foregroundStyle(entry.streakCount > 0 ? .orange : .gray)

            Text("\(entry.streakCount)")
                .font(.system(size: 32, weight: .bold, design: .rounded))

            Text(entry.streakCount == 1 ? "day streak" : "day streak")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Medium Widget

private struct MediumWidgetView: View {
    let entry: UnplugWidgetEntry

    var body: some View {
        HStack(spacing: 16) {
            // Streak
            VStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(entry.streakCount > 0 ? .orange : .gray)
                Text("\(entry.streakCount)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text("streak")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)

            Divider()

            // Sessions
            VStack(spacing: 4) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.green)
                Text("\(entry.todaySessionCount)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text("sessions")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)

            Divider()

            // Minutes Saved
            VStack(spacing: 4) {
                Image(systemName: "clock.badge.checkmark")
                    .font(.system(size: 28))
                    .foregroundStyle(.blue)
                Text("\(entry.minutesSaved)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text("min saved")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)

            // Mood (if available)
            if !entry.latestMoodEmoji.isEmpty {
                Divider()
                VStack(spacing: 4) {
                    Text(entry.latestMoodEmoji)
                        .font(.system(size: 28))
                    Text("mood")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Large Widget

private struct LargeWidgetView: View {
    let entry: UnplugWidgetEntry

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Unplug")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                Spacer()
                if !entry.latestMoodEmoji.isEmpty {
                    Text(entry.latestMoodEmoji)
                        .font(.system(size: 24))
                }
            }

            // Streak Hero
            HStack(spacing: 12) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(entry.streakCount > 0 ? .orange : .gray)

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(entry.streakCount) day streak")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text(entry.streakCount > 0 ? "Keep going!" : "Start your streak today")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding(12)
            .background(.fill.quaternary)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Stats Grid
            HStack(spacing: 12) {
                StatBox(
                    icon: "hand.raised.fill",
                    iconColor: .green,
                    value: "\(entry.todaySessionCount)",
                    label: "Sessions Today"
                )

                StatBox(
                    icon: "clock.badge.checkmark",
                    iconColor: .blue,
                    value: "\(entry.minutesSaved) min",
                    label: "Minutes Saved"
                )
            }

            Spacer(minLength: 0)

            // Footer
            Text("Tap to open Unplug")
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(.tertiary)
        }
    }
}

private struct StatBox: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(iconColor)
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.fill.quaternary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

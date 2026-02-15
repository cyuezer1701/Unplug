import SwiftUI
import WidgetKit

struct UnplugWidgetEntry: TimelineEntry {
    let date: Date
    let streakCount: Int
    let todaySessionCount: Int
    let minutesSaved: Int
    let latestMoodEmoji: String

    static let placeholder = UnplugWidgetEntry(
        date: .now,
        streakCount: 5,
        todaySessionCount: 3,
        minutesSaved: 45,
        latestMoodEmoji: "😊"
    )
}

struct UnplugTimelineProvider: TimelineProvider {
    private let suiteName = "group.io.unplug.app"

    func placeholder(in _: Context) -> UnplugWidgetEntry {
        .placeholder
    }

    func getSnapshot(in _: Context, completion: @escaping (UnplugWidgetEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<UnplugWidgetEntry>) -> Void) {
        let entry = readEntry()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: .now) ?? .now
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func readEntry() -> UnplugWidgetEntry {
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            return .placeholder
        }

        return UnplugWidgetEntry(
            date: .now,
            streakCount: defaults.integer(forKey: "widgetStreakCount"),
            todaySessionCount: defaults.integer(forKey: "widgetTodaySessionCount"),
            minutesSaved: defaults.integer(forKey: "widgetMinutesSaved"),
            latestMoodEmoji: defaults.string(forKey: "widgetLatestMoodEmoji") ?? ""
        )
    }
}

@main
struct UnplugWidgetBundle: WidgetBundle {
    var body: some Widget {
        UnplugWidget()
    }
}

struct UnplugWidget: Widget {
    let kind = "UnplugWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: UnplugTimelineProvider()) { entry in
            UnplugWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Unplug")
        .description("Track your streak and mindful moments.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

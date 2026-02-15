import Charts
import SwiftUI

struct MoodTrendChart: View {
    let data: [InsightsCalculator.DayValue]

    var body: some View {
        Chart(data, id: \.date) { item in
            LineMark(
                x: .value("Day", item.date, unit: .day),
                y: .value("Mood", item.value)
            )
            .foregroundStyle(UnplugTheme.Colors.primarySage)
            .interpolationMethod(.catmullRom)

            PointMark(
                x: .value("Day", item.date, unit: .day),
                y: .value("Mood", item.value)
            )
            .foregroundStyle(UnplugTheme.Colors.primarySage)

            AreaMark(
                x: .value("Day", item.date, unit: .day),
                y: .value("Mood", item.value)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        UnplugTheme.Colors.primarySage.opacity(0.3),
                        UnplugTheme.Colors.primarySage.opacity(0.05),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .interpolationMethod(.catmullRom)
        }
        .chartYScale(domain: 1...5)
        .chartYAxis {
            AxisMarks(values: [1, 2, 3, 4, 5]) { value in
                AxisValueLabel {
                    if let level = value.as(Int.self) {
                        Text(moodEmoji(for: level))
                            .font(.caption2)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisValueLabel(format: .dateTime.weekday(.abbreviated))
            }
        }
        .frame(height: 180)
    }

    private func moodEmoji(for level: Int) -> String {
        switch level {
        case 1: return "😢"
        case 2: return "😕"
        case 3: return "😐"
        case 4: return "😊"
        case 5: return "😄"
        default: return ""
        }
    }
}

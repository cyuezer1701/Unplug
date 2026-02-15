import Charts
import SwiftUI

struct TriggerFrequencyChart: View {
    let data: [InsightsCalculator.TriggerCount]

    var body: some View {
        Chart(data, id: \.trigger) { item in
            BarMark(
                x: .value("Count", item.count),
                y: .value("Trigger", item.trigger.displayName)
            )
            .foregroundStyle(UnplugTheme.Colors.accentCoral.gradient)
            .cornerRadius(4)
            .annotation(position: .trailing) {
                Text("\(item.count)")
                    .font(.unplugCaption())
                    .foregroundStyle(UnplugTheme.Colors.textSecondary)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let label = value.as(String.self) {
                        Text(label)
                            .font(.unplugCaption())
                    }
                }
            }
        }
        .frame(height: CGFloat(max(data.count, 1)) * 40)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(chartAccessibilityLabel)
    }

    private var chartAccessibilityLabel: String {
        guard !data.isEmpty else { return "Trigger frequency chart, no data" }
        let items = data.prefix(3).map { "\($0.trigger.displayName) \($0.count) times" }
        return "Trigger frequency chart: \(items.joined(separator: ", "))"
    }
}

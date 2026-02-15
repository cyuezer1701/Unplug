import Foundation

enum StreakCalculator {
    static func isStreakActive(lastDate: Date, now: Date = .now) -> Bool {
        let calendar = Calendar.current
        let daysBetween = calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: lastDate),
            to: calendar.startOfDay(for: now)
        ).day ?? 0
        return daysBetween <= 1
    }

    static func calculateNewCount(
        currentCount: Int,
        lastDate: Date,
        now: Date = .now
    ) -> Int {
        if isStreakActive(lastDate: lastDate, now: now) {
            let calendar = Calendar.current
            if calendar.isDate(lastDate, inSameDayAs: now) {
                return currentCount
            }
            return currentCount + 1
        }
        return 1
    }

    static func updateLongest(current: Int, longest: Int) -> Int {
        max(current, longest)
    }
}

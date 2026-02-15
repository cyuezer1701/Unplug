import Foundation

enum TimeOfDay {
    case morning   // 5-12
    case afternoon // 12-17
    case evening   // 17-21
    case night     // 21-5

    init(from date: Date) {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<12: self = .morning
        case 12..<17: self = .afternoon
        case 17..<21: self = .evening
        default: self = .night
        }
    }
}

enum AlternativeSuggester {

    // MARK: - Catalog

    static let catalog: [Alternative] = [
        // Movement
        Alternative(title: "Quick Walk", description: "Step outside for a 10-minute walk around your block", category: .movement, durationMinutes: 10, requiresOutdoor: true, energyLevel: 2),
        Alternative(title: "Stretch Break", description: "Follow a simple full-body stretch routine", category: .movement, durationMinutes: 5, energyLevel: 1),
        Alternative(title: "Dance It Out", description: "Put on your favorite song and dance like nobody's watching", category: .movement, durationMinutes: 5, energyLevel: 4),
        Alternative(title: "Yoga Flow", description: "Do a gentle 10-minute yoga sequence", category: .movement, durationMinutes: 10, energyLevel: 2),
        Alternative(title: "Jump Rope", description: "Get your heart pumping with a quick jump rope session", category: .movement, durationMinutes: 5, requiresEquipment: true, energyLevel: 5),

        // Mindfulness
        Alternative(title: "Box Breathing", description: "Breathe in 4 seconds, hold 4, out 4, hold 4. Repeat 5 times", category: .mindfulness, durationMinutes: 3, energyLevel: 1),
        Alternative(title: "Body Scan", description: "Close your eyes and slowly scan from head to toe, releasing tension", category: .mindfulness, durationMinutes: 10, energyLevel: 1),
        Alternative(title: "Gratitude List", description: "Write down 3 things you're grateful for right now", category: .mindfulness, durationMinutes: 5, energyLevel: 1),
        Alternative(title: "Mindful Tea", description: "Make a cup of tea and focus fully on the process and taste", category: .mindfulness, durationMinutes: 10, energyLevel: 1),

        // Creative
        Alternative(title: "Quick Sketch", description: "Draw whatever comes to mind for 10 minutes", category: .creative, durationMinutes: 10, energyLevel: 2),
        Alternative(title: "Write a Haiku", description: "Express your current mood in a 5-7-5 syllable poem", category: .creative, durationMinutes: 5, energyLevel: 2),
        Alternative(title: "Playlist Curator", description: "Create a playlist that matches your current vibe", category: .creative, durationMinutes: 10, energyLevel: 1),
        Alternative(title: "Photo Walk", description: "Take 5 interesting photos of things around you", category: .creative, durationMinutes: 10, requiresOutdoor: true, energyLevel: 2),

        // Social
        Alternative(title: "Text a Friend", description: "Send a genuine message to someone you haven't talked to in a while", category: .social, durationMinutes: 5, energyLevel: 1),
        Alternative(title: "Voice Note", description: "Record a quick voice message for someone you care about", category: .social, durationMinutes: 3, energyLevel: 2),
        Alternative(title: "Random Kindness", description: "Do one small kind thing for someone nearby", category: .social, durationMinutes: 10, energyLevel: 2),

        // Learning
        Alternative(title: "Read 5 Pages", description: "Pick up that book you've been meaning to read", category: .learning, durationMinutes: 10, energyLevel: 1),
        Alternative(title: "Learn a Word", description: "Look up an interesting word in a language you're learning", category: .learning, durationMinutes: 5, energyLevel: 2),
        Alternative(title: "TED Talk", description: "Watch one short TED talk on a topic that fascinates you", category: .learning, durationMinutes: 15, energyLevel: 1),
        Alternative(title: "Skill Practice", description: "Spend 10 minutes practicing a skill you're developing", category: .learning, durationMinutes: 10, energyLevel: 3),

        // Outdoor
        Alternative(title: "Cloud Gazing", description: "Go outside and watch the clouds for 5 minutes", category: .outdoor, durationMinutes: 5, requiresOutdoor: true, energyLevel: 1),
        Alternative(title: "Nature Sounds", description: "Step outside and listen to the sounds around you", category: .outdoor, durationMinutes: 5, requiresOutdoor: true, energyLevel: 1),
        Alternative(title: "Park Visit", description: "Walk to the nearest park and sit on a bench for a bit", category: .outdoor, durationMinutes: 15, requiresOutdoor: true, energyLevel: 2),

        // Self-Care
        Alternative(title: "Face Splash", description: "Splash cold water on your face for a quick reset", category: .selfCare, durationMinutes: 2, energyLevel: 1),
        Alternative(title: "Hand Massage", description: "Give yourself a gentle 3-minute hand massage", category: .selfCare, durationMinutes: 3, energyLevel: 1),
        Alternative(title: "Tidy One Spot", description: "Clean or organize one small area around you", category: .selfCare, durationMinutes: 10, energyLevel: 2),
        Alternative(title: "Skincare Routine", description: "Take your time with a mini skincare moment", category: .selfCare, durationMinutes: 10, energyLevel: 1),
    ]

    // MARK: - Suggestion Engine

    static func suggest(
        trigger: Trigger,
        timeOfDay: Date = .now,
        energyLevel: Int = 3
    ) -> [Alternative] {
        let time = TimeOfDay(from: timeOfDay)
        let affinityMap = categoryAffinity(for: trigger)

        let scored = catalog
            .filter { passesFilters($0, time: time) }
            .map { alternative -> (Alternative, Double) in
                let score = calculateScore(
                    alternative: alternative,
                    affinityMap: affinityMap,
                    energyLevel: energyLevel,
                    time: time
                )
                return (alternative, score)
            }
            .sorted { $0.1 > $1.1 }

        return Array(scored.prefix(5).map(\.0))
    }

    // MARK: - Private

    private static func passesFilters(_ alt: Alternative, time: TimeOfDay) -> Bool {
        if alt.requiresOutdoor && time == .night {
            return false
        }
        return true
    }

    private static func calculateScore(
        alternative: Alternative,
        affinityMap: [AlternativeCategory: Double],
        energyLevel: Int,
        time: TimeOfDay
    ) -> Double {
        var score = 0.0

        // Category affinity (0-1, weighted heavily)
        score += (affinityMap[alternative.category] ?? 0.1) * 10.0

        // Energy match (closer = better, max 3 points)
        let energyDiff = abs(alternative.energyLevel - energyLevel)
        score += max(0, 3.0 - Double(energyDiff))

        // Time-of-day bonus
        score += timeBonus(for: alternative, time: time)

        // Prefer shorter activities (slight bonus for quick wins)
        if alternative.durationMinutes <= 5 {
            score += 1.0
        }

        // Penalize equipment requirement slightly
        if alternative.requiresEquipment {
            score -= 0.5
        }

        return score
    }

    private static func timeBonus(for alt: Alternative, time: TimeOfDay) -> Double {
        switch time {
        case .morning:
            if alt.category == .movement { return 2.0 }
            if alt.category == .outdoor { return 1.0 }
        case .afternoon:
            if alt.category == .creative { return 1.0 }
            if alt.category == .learning { return 1.0 }
        case .evening:
            if alt.category == .selfCare { return 1.5 }
            if alt.category == .social { return 1.0 }
        case .night:
            if alt.category == .mindfulness { return 2.0 }
            if alt.category == .selfCare { return 1.5 }
            if alt.category == .movement { return -1.0 }
        }
        return 0
    }

    private static func categoryAffinity(for trigger: Trigger) -> [AlternativeCategory: Double] {
        switch trigger {
        case .boredom:
            return [.creative: 1.0, .learning: 0.9, .movement: 0.6, .outdoor: 0.5, .social: 0.4]
        case .stress:
            return [.mindfulness: 1.0, .movement: 0.9, .selfCare: 0.8, .outdoor: 0.6]
        case .procrastination:
            return [.movement: 1.0, .selfCare: 0.7, .creative: 0.6, .outdoor: 0.5]
        case .habit:
            return [.mindfulness: 0.9, .movement: 0.8, .creative: 0.7, .selfCare: 0.6, .learning: 0.5]
        case .fomo:
            return [.social: 1.0, .creative: 0.7, .outdoor: 0.6, .learning: 0.5]
        case .loneliness:
            return [.social: 1.0, .outdoor: 0.7, .creative: 0.6, .movement: 0.5]
        case .anxiety:
            return [.mindfulness: 1.0, .selfCare: 0.9, .movement: 0.7, .outdoor: 0.5]
        case .insomnia:
            return [.mindfulness: 1.0, .selfCare: 0.9, .creative: 0.4]
        }
    }
}

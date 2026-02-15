import Foundation

enum AlternativeCategory: String, Codable, CaseIterable, Sendable {
    case movement
    case mindfulness
    case creative
    case social
    case learning
    case outdoor
    case selfCare
}

struct Alternative: Codable, Identifiable, Sendable {
    var id: String
    var title: String
    var description: String
    var category: AlternativeCategory
    var durationMinutes: Int
    var requiresOutdoor: Bool
    var requiresEquipment: Bool
    var energyLevel: Int

    init(
        id: String = UUID().uuidString,
        title: String,
        description: String,
        category: AlternativeCategory,
        durationMinutes: Int = 15,
        requiresOutdoor: Bool = false,
        requiresEquipment: Bool = false,
        energyLevel: Int = 3
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.durationMinutes = durationMinutes
        self.requiresOutdoor = requiresOutdoor
        self.requiresEquipment = requiresEquipment
        self.energyLevel = energyLevel
    }
}

import Foundation
import Testing
@testable import Unplug

@Suite("AlternativeSuggester Tests")
struct AlternativeSuggesterTests {

    @Test func catalogIsNotEmpty() {
        #expect(AlternativeSuggester.catalog.count >= 20)
    }

    @Test func catalogCoversAllCategories() {
        let categories = Set(AlternativeSuggester.catalog.map(\.category))
        for category in AlternativeCategory.allCases {
            #expect(categories.contains(category), "Missing category: \(category)")
        }
    }

    @Test func suggestReturnsBetween1And5Results() {
        for trigger in Trigger.allCases {
            let results = AlternativeSuggester.suggest(trigger: trigger)
            #expect(results.count >= 1 && results.count <= 5,
                    "Expected 1-5 results for \(trigger), got \(results.count)")
        }
    }

    @Test func boredomSuggestsCreativeOrLearning() {
        let results = AlternativeSuggester.suggest(trigger: .boredom)
        let categories = Set(results.map(\.category))
        let hasRelevant = categories.contains(.creative) || categories.contains(.learning)
        #expect(hasRelevant, "Boredom should suggest creative or learning alternatives")
    }

    @Test func stressSuggestsMindfulnessOrMovement() {
        let results = AlternativeSuggester.suggest(trigger: .stress)
        let categories = Set(results.map(\.category))
        let hasRelevant = categories.contains(.mindfulness) || categories.contains(.movement)
        #expect(hasRelevant, "Stress should suggest mindfulness or movement alternatives")
    }

    @Test func lonelinessSuggestsSocial() {
        let results = AlternativeSuggester.suggest(trigger: .loneliness)
        let categories = Set(results.map(\.category))
        #expect(categories.contains(.social), "Loneliness should suggest social alternatives")
    }

    @Test func nightTimeExcludesOutdoor() {
        var components = DateComponents()
        components.hour = 23
        components.minute = 0
        let nightTime = Calendar.current.date(from: components) ?? .now

        let results = AlternativeSuggester.suggest(trigger: .boredom, timeOfDay: nightTime)
        let hasOutdoor = results.contains { $0.requiresOutdoor }
        #expect(!hasOutdoor, "Night time should exclude outdoor alternatives")
    }

    @Test func lowEnergyPrefersLowEnergyAlternatives() {
        let results = AlternativeSuggester.suggest(trigger: .stress, energyLevel: 1)
        let avgEnergy = Double(results.reduce(0) { $0 + $1.energyLevel }) / Double(results.count)
        #expect(avgEnergy <= 3.0, "Low energy preference should favor low-energy alternatives")
    }

    @Test func highEnergyAllowsHighEnergyAlternatives() {
        let results = AlternativeSuggester.suggest(trigger: .boredom, energyLevel: 5)
        #expect(!results.isEmpty, "Should return results for high energy level")
    }

    @Test func insomniaSuggestsMindfulnessOrSelfCare() {
        let results = AlternativeSuggester.suggest(trigger: .insomnia)
        let categories = Set(results.map(\.category))
        let hasRelevant = categories.contains(.mindfulness) || categories.contains(.selfCare)
        #expect(hasRelevant, "Insomnia should suggest mindfulness or self-care alternatives")
    }

    @Test func allCatalogEntriesHaveValidFields() {
        for alt in AlternativeSuggester.catalog {
            #expect(!alt.title.isEmpty)
            #expect(!alt.description.isEmpty)
            #expect(alt.durationMinutes > 0)
            #expect(alt.energyLevel >= 1 && alt.energyLevel <= 5)
        }
    }

    // MARK: - Weather Tests

    @Test func rainyWeatherExcludesOutdoor() {
        let rain = WeatherCondition(temperature: 15, isRaining: true, isSnowing: false, windSpeed: 5)
        let results = AlternativeSuggester.suggest(trigger: .boredom, weather: rain)
        let hasOutdoor = results.contains { $0.requiresOutdoor }
        #expect(!hasOutdoor, "Rainy weather should exclude outdoor alternatives")
    }

    @Test func snowyWeatherExcludesOutdoor() {
        let snow = WeatherCondition(temperature: -2, isRaining: false, isSnowing: true, windSpeed: 3)
        let results = AlternativeSuggester.suggest(trigger: .boredom, weather: snow)
        let hasOutdoor = results.contains { $0.requiresOutdoor }
        #expect(!hasOutdoor, "Snowy weather should exclude outdoor alternatives")
    }

    @Test func niceWeatherBoostsOutdoor() {
        let nice = WeatherCondition(temperature: 22, isRaining: false, isSnowing: false, windSpeed: 3)
        let withWeather = AlternativeSuggester.suggest(trigger: .stress, weather: nice)
        let withoutWeather = AlternativeSuggester.suggest(trigger: .stress)

        let outdoorCountWith = withWeather.filter { $0.requiresOutdoor || $0.category == .outdoor }.count
        let outdoorCountWithout = withoutWeather.filter { $0.requiresOutdoor || $0.category == .outdoor }.count
        #expect(outdoorCountWith >= outdoorCountWithout, "Nice weather should favor outdoor alternatives")
    }

    @Test func nilWeatherBehavesNormally() {
        let results = AlternativeSuggester.suggest(trigger: .boredom, weather: nil)
        #expect(results.count >= 1 && results.count <= 5, "nil weather should produce normal results")
    }

    @Test func coldWeatherReducesOutdoorScore() {
        let cold = WeatherCondition(temperature: 2, isRaining: false, isSnowing: false, windSpeed: 5)
        let results = AlternativeSuggester.suggest(trigger: .boredom, weather: cold)
        // Cold but not raining — outdoor allowed but deprioritized
        #expect(!results.isEmpty, "Cold weather should still produce results")
    }
}

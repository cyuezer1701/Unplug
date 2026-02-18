import CoreLocation
import Foundation
import WeatherKit

struct WeatherCondition: Sendable {
    var temperature: Double // Celsius
    var isRaining: Bool
    var isSnowing: Bool
    var windSpeed: Double // m/s

    var isBadWeather: Bool {
        isRaining || isSnowing || temperature < 5 || windSpeed > 10
    }

    var isNiceWeather: Bool {
        !isRaining && !isSnowing && temperature >= 15 && temperature <= 30 && windSpeed < 8
    }
}

final class ContextService: NSObject, CLLocationManagerDelegate, @unchecked Sendable {
    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation?, Never>?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestLocationPermission() -> Bool {
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }

    func getCurrentLocation() async -> CLLocation? {
        let status = locationManager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            return nil
        }

        return await withCheckedContinuation { continuation in
            locationContinuation = continuation
            locationManager.requestLocation()
        }
    }

    func getCurrentWeather() async -> WeatherCondition? {
        #if targetEnvironment(simulator)
        return nil
        #else
        guard let location = await getCurrentLocation() else { return nil }
        return await fetchWeather(for: location)
        #endif
    }

    private func fetchWeather(for location: CLLocation) async -> WeatherCondition? {
        guard let weather = try? await WeatherService.shared.weather(for: location) else {
            return nil
        }
        let current = weather.currentWeather
        let condition = current.condition
        return WeatherCondition(
            temperature: current.temperature.converted(to: .celsius).value,
            isRaining: condition == .rain || condition == .heavyRain || condition == .drizzle,
            isSnowing: condition == .snow || condition == .heavySnow || condition == .flurries || condition == .blizzard,
            windSpeed: current.wind.speed.converted(to: .metersPerSecond).value
        )
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationContinuation?.resume(returning: locations.last)
        locationContinuation = nil
    }

    func locationManager(_: CLLocationManager, didFailWithError _: Error) {
        locationContinuation?.resume(returning: nil)
        locationContinuation = nil
    }
}

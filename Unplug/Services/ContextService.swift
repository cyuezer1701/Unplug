import CoreLocation
import Foundation

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

    private func fetchWeather(for _: CLLocation) async -> WeatherCondition? {
        // WeatherKit requires Apple Developer Program + entitlement
        // Graceful fallback: return nil if not available
        // Full integration would use:
        // let weather = try? await WeatherService.shared.weather(for: location)
        return nil
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

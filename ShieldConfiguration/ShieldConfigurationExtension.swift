import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    private let defaults = UserDefaults(suiteName: "group.io.unplug.app")
    private let sageGreen = UIColor(red: 0.56, green: 0.74, blue: 0.56, alpha: 1)

    override func configuration(
        shielding application: Application
    ) -> ShieldConfiguration {
        let limitMinutes = defaults?.integer(forKey: "dailyScrollLimitMinutes") ?? 60

        return ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterial,
            title: ShieldConfiguration.Label(
                text: "Time for a break!",
                color: sageGreen
            ),
            subtitle: ShieldConfiguration.Label(
                text: "You've reached your \(limitMinutes)-minute limit. Try something different?",
                color: .secondaryLabel
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "Open Unplug",
                color: .white
            ),
            primaryButtonBackgroundColor: sageGreen,
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "Dismiss",
                color: .secondaryLabel
            )
        )
    }
}

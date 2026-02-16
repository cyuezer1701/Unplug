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
                text: String(localized: "shield.title"),
                color: sageGreen
            ),
            subtitle: ShieldConfiguration.Label(
                text: String(localized: "shield.subtitle \(limitMinutes)"),
                color: .secondaryLabel
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: String(localized: "shield.primaryButton"),
                color: .white
            ),
            primaryButtonBackgroundColor: sageGreen,
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: String(localized: "shield.secondaryButton"),
                color: .secondaryLabel
            )
        )
    }
}

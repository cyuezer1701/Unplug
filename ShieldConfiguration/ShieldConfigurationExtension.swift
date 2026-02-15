import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(
        shielding application: Application
    ) -> ShieldConfiguration {
        // Phase 2: Custom shield UI with Unplug branding
        ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterial,
            title: ShieldConfiguration.Label(
                text: "Time for a break!",
                color: UIColor(red: 0.56, green: 0.74, blue: 0.56, alpha: 1)
            ),
            subtitle: ShieldConfiguration.Label(
                text: "You've been scrolling. Try something else?",
                color: .secondaryLabel
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "Show Alternative",
                color: .white
            ),
            primaryButtonBackgroundColor: UIColor(red: 0.56, green: 0.74, blue: 0.56, alpha: 1),
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "Dismiss",
                color: .secondaryLabel
            )
        )
    }
}

import SwiftUI

extension Animation {
    static var unplugSpring: Animation {
        .spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.1)
    }

    static var unplugBounce: Animation {
        .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)
    }

    static var unplugGentle: Animation {
        .easeInOut(duration: 0.3)
    }

    static var unplugSlow: Animation {
        .easeInOut(duration: 0.6)
    }
}

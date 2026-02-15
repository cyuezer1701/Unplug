import SwiftUI
import UIKit

extension Animation {
    private static var reduceMotion: Bool {
        UIAccessibility.isReduceMotionEnabled
    }

    static var unplugSpring: Animation {
        reduceMotion
            ? .easeInOut(duration: 0.2)
            : .spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.1)
    }

    static var unplugBounce: Animation {
        reduceMotion
            ? .easeInOut(duration: 0.2)
            : .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)
    }

    static var unplugGentle: Animation {
        .easeInOut(duration: reduceMotion ? 0.15 : 0.3)
    }

    static var unplugSlow: Animation {
        .easeInOut(duration: reduceMotion ? 0.2 : 0.6)
    }
}

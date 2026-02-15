# Unplug

A smart dopamine rebalancer for Gen Z. Detects doom-scrolling in real-time and suggests context-aware "slow dopamine" alternatives based on location, time, weather, and mood.

## Tech Stack

- **Swift/SwiftUI** (iOS 17+)
- **Firebase** (Auth + Firestore)
- **Apple Screen Time API** (DeviceActivityFramework)
- **XcodeGen** for project generation

## Getting Started

### Prerequisites

- Xcode 16+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`
- Apple Developer Account (for Screen Time API entitlements)

### Setup

1. Clone the repository
2. Generate the Xcode project:
   ```bash
   xcodegen generate
   ```
3. Place your `GoogleService-Info.plist` in `Unplug/` (get it from Firebase Console)
4. Open `Unplug.xcodeproj` in Xcode
5. Select your team in Signing & Capabilities
6. Build and run on Simulator or device

### Commands

```bash
# Generate Xcode project
xcodegen generate

# Build
xcodebuild build -scheme Unplug -destination 'platform=iOS Simulator,name=iPhone 17 Pro'

# Run tests
xcodebuild test -scheme Unplug -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## Architecture

See [CLAUDE.md](CLAUDE.md) for full architecture documentation.

## CI/CD

GitHub Actions runs on every push and PR:
- Build verification
- Unit test execution
- Test results uploaded as artifacts

## License

Private — All rights reserved.

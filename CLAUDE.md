# Project: Unplug — iOS App (Swift/SwiftUI + Firebase)

## Architecture Overview

Native iOS application (iOS 17+) using SwiftUI, Firebase for backend services (Firestore + Auth), and Apple Screen Time API for scroll detection. Helps users break doom-scrolling habits with context-aware alternatives, gamification, and social accountability.

## Tech Stack

- **Language:** Swift 5.9+ (targeting iOS 17+)
- **UI:** SwiftUI with @Observable state management
- **Backend:** Firebase (Auth, Firestore) via SPM
- **APIs:** DeviceActivityFramework, FamilyControls, CoreLocation, WeatherKit
- **Build:** XcodeGen (project.yml → .xcodeproj)
- **Testing:** Swift Testing framework

## Directory Structure

```
Unplug/                        # Main app target
  Models/                      - Data models (Codable + Identifiable + Sendable)
  Core/                        - Pure business logic (NO SwiftUI, NO Firebase imports)
  Services/
    Firebase/                  - Auth, Firestore services
    ScreenTime/                - DeviceActivityFramework integration
    Notifications/             - Local + Push notifications
  State/                       - App state (@Observable classes)
  Views/
    Onboarding/                - 5-screen onboarding flow
    Home/                      - Dashboard
    Insights/                  - Analytics & graphs
    Social/                    - Buddy system
    Settings/                  - Profile & preferences
  Components/                  - Reusable SwiftUI components
  Theme/                       - Design system (colors, typography, animations)
  Extensions/                  - Swift extensions
  Resources/                   - Assets, Localization
UnplugTests/                   - Unit tests (Swift Testing)
  Core/                        - Pure logic tests
  Models/                      - Model tests
  State/                       - State management tests
UnplugUITests/                 - UI tests
DeviceActivityMonitor/         - Background monitoring extension
ShieldConfiguration/           - Shield UI customization extension
```

## Key Patterns

- **@Observable State**: `State/AppState.swift` — main app state using Observation framework
- **Pure Logic Separation**: `Core/` has ZERO imports of SwiftUI or Firebase
- **Codable Models**: All models conform to `Codable` for Firestore serialization
- **Environment Injection**: Services passed via SwiftUI `.environment()`
- **Design System**: `Theme/UnplugTheme.swift` — centralized color, spacing, radius tokens
- **SF Pro Rounded**: Typography via `Font.unplugTitle()`, `.unplugBody()`, etc.
- **Spring Animations**: `Animation.unplugSpring`, `.unplugBounce`, `.unplugGentle`

## Commands

- `xcodegen generate` — Regenerate Xcode project from project.yml
- `xcodebuild build -scheme Unplug -destination 'platform=iOS Simulator,name=iPhone 17 Pro'` — Build
- `xcodebuild test -scheme Unplug -destination 'platform=iOS Simulator,name=iPhone 17 Pro'` — Run tests

## Testing Conventions

- Unit tests in `UnplugTests/` using Swift Testing (`import Testing`, `@Test`, `#expect`)
- Test files match source: `StreakCalculator.swift` → `StreakCalculatorTests.swift`
- Core/ logic: 90%+ coverage target
- Pure logic tests: no mocking needed
- All tests must pass before committing

## Teamstruktur / Agent Hierarchy

```
CEO (User) — gibt Aufgaben und Anweisungen
  |
  PM (/pm) — Zentraler Orchestrator, einziger Ansprechpartner des CEO
    |
    +-- Developer (/dev) — Implementierung, Debugging, Code Review
    +-- Designer (/designer) — UI/UX Design, Styling, Accessibility
    +-- Tester (/tester) — Tests, Coverage, Qualitaetssicherung
    +-- [Dynamische Agenten nach Bedarf]
```

### Arbeitsweise

1. **CEO** gibt dem PM eine Aufgabe
2. **PM** analysiert, zerlegt in Teilaufgaben, erstellt einen Delegationsplan
3. **PM** gibt dem CEO die genaue Reihenfolge der `/command` Aufrufe vor
4. **CEO** fuehrt die Befehle der Reihe nach aus und gibt Ergebnisse an den PM zurueck
5. **PM** prueft Ergebnisse, koordiniert Nacharbeit, meldet Abschluss an den CEO

## Rules

- Always run `xcodegen generate` after modifying project.yml
- Always run tests after modifying Core/ or Models/
- Never commit GoogleService-Info.plist or .env files
- Pure logic in Core/ (no SwiftUI, no Firebase imports)
- All user-facing strings should be localized
- New reusable views go in Components/
- WCAG AA accessibility on all interactive elements (VoiceOver labels, Dynamic Type)
- Always start with `/pm` for any new feature or task
- The PM is the single point of coordination for all work

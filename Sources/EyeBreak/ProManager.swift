import Foundation

// MARK: - Pro Manager (Open Core Stub)
//
// This is the public/free version. `isPro` is always false.
// Pro features are built in a separate private build with StoreKit integration.
//
// To enable Pro features locally:
//   1. Create Sources/EyeBreak/Pro/ folder (gitignored)
//   2. Add ProFeatures.swift with StoreKit 2 integration
//   3. Replace this file's `isPro` logic with a real check

@MainActor
final class ProManager: ObservableObject {
    static let shared = ProManager()

    @Published private(set) var isPro: Bool = false

    private init() {
        // Free version: Pro is always disabled
    }

    /// Check if a feature is available in the current build
    func isAvailable(_ feature: ProFeature) -> Bool {
        feature.isFree || isPro
    }
}

enum ProFeature {
    case weeklyStats
    case customSounds
    case customOverlay
    case pomodoroMode
    case monthlyReports

    var isFree: Bool { false }

    var displayName: String {
        switch self {
        case .weeklyStats:    return "Weekly Statistics"
        case .customSounds:   return "Custom Alert Sounds"
        case .customOverlay:  return "Overlay Customization"
        case .pomodoroMode:   return "Pomodoro Mode"
        case .monthlyReports: return "Monthly Reports"
        }
    }
}

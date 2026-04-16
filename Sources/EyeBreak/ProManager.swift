import Foundation

@MainActor
final class ProManager: ObservableObject {
    static let shared = ProManager()

    @Published var isPro: Bool {
        didSet { UserDefaults.standard.set(isPro, forKey: "eyebreak.isPro") }
    }

    private init() {
        self.isPro = UserDefaults.standard.bool(forKey: "eyebreak.isPro")
    }

    // TODO: Replace with StoreKit 2 for App Store distribution
    // For now, this is a placeholder that can be toggled for testing
    func unlock() {
        isPro = true
    }

    func restore() {
        // StoreKit restore purchases will go here
    }
}

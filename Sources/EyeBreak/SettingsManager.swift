import Foundation
import ServiceManagement

@MainActor
final class SettingsManager: ObservableObject {
    private let defaults = UserDefaults.standard
    private enum Key {
        static let interval = "eyebreak.intervalMinutes"
        static let sound = "eyebreak.soundEnabled"
        static let autoStart = "eyebreak.autoStartOnLogin"
        static let breaksToday = "eyebreak.breaksToday"
        static let lastDate = "eyebreak.lastActiveDate"
        static let screenTime = "eyebreak.screenTimeAccumulated"
        static let language = "eyebreak.language"
    }

    @Published var appLanguage: AppLanguage {
        didSet {
            defaults.set(appLanguage.rawValue, forKey: Key.language)
            L10n.lang = appLanguage
        }
    }

    @Published var intervalMinutes: Int {
        didSet { defaults.set(intervalMinutes, forKey: Key.interval) }
    }

    @Published var soundEnabled: Bool {
        didSet { defaults.set(soundEnabled, forKey: Key.sound) }
    }

    @Published var autoStartOnLogin: Bool {
        didSet {
            defaults.set(autoStartOnLogin, forKey: Key.autoStart)
            updateLoginItem()
        }
    }

    var breaksTakenToday: Int {
        get { defaults.integer(forKey: Key.breaksToday) }
        set { defaults.set(newValue, forKey: Key.breaksToday) }
    }

    var lastActiveDate: String {
        get { defaults.string(forKey: Key.lastDate) ?? "" }
        set { defaults.set(newValue, forKey: Key.lastDate) }
    }

    var screenTimeAccumulated: TimeInterval {
        get { defaults.double(forKey: Key.screenTime) }
        set { defaults.set(newValue, forKey: Key.screenTime) }
    }

    init() {
        let d = UserDefaults.standard
        if let langRaw = d.string(forKey: Key.language),
           let lang = AppLanguage(rawValue: langRaw) {
            self.appLanguage = lang
        } else {
            self.appLanguage = .system
        }
        self.intervalMinutes = d.object(forKey: Key.interval) as? Int ?? 20
        self.soundEnabled = d.object(forKey: Key.sound) as? Bool ?? true
        self.autoStartOnLogin = d.object(forKey: Key.autoStart) as? Bool ?? false
        L10n.lang = self.appLanguage
    }

    private func updateLoginItem() {
        do {
            if autoStartOnLogin {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("Login item error: \(error)")
        }
    }
}

import Foundation

enum AppLanguage: String, CaseIterable {
    case arabic = "ar"
    case english = "en"

    var displayName: String {
        switch self {
        case .arabic: return "العربية"
        case .english: return "English"
        }
    }

    static var system: AppLanguage {
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        return code == "ar" ? .arabic : .english
    }
}

enum L10n {
    static var lang: AppLanguage = .system

    // MARK: - Menu Bar
    static var appName: String { "EyeBreak" }

    static var statusRunning: String {
        lang == .arabic ? "شغّال" : "Running"
    }
    static var statusPaused: String {
        lang == .arabic ? "متوقف" : "Paused"
    }
    static var statusBreak: String {
        lang == .arabic ? "استراحة" : "Break"
    }

    // MARK: - Timer Display
    static var nextBreak: String {
        lang == .arabic ? "الاستراحة القادمة" : "Next break"
    }
    static var readyToStart: String {
        lang == .arabic ? "جاهز للتشغيل" : "Ready to start"
    }
    static var lookAway: String {
        lang == .arabic ? "انظر بعيداً..." : "Look away..."
    }
    static var seconds: String {
        lang == .arabic ? "ثانية" : "sec"
    }

    // MARK: - Controls
    static var start: String {
        lang == .arabic ? "تشغيل" : "Start"
    }
    static var pause: String {
        lang == .arabic ? "إيقاف" : "Pause"
    }
    static var resume: String {
        lang == .arabic ? "استئناف" : "Resume"
    }
    static var skip: String {
        lang == .arabic ? "تخطي" : "Skip"
    }
    static var snooze: String {
        lang == .arabic ? "تأجيل" : "Snooze"
    }
    static func minutes(_ n: Int) -> String {
        lang == .arabic ? "\(n) دقائق" : "\(n) min"
    }

    // MARK: - Stats
    static var breaks: String {
        lang == .arabic ? "استراحات" : "Breaks"
    }
    static var screenTime: String {
        lang == .arabic ? "وقت الشاشة" : "Screen time"
    }
    static func hoursMinutes(_ h: Int, _ m: Int) -> String {
        if lang == .arabic {
            return h > 0 ? "\(h) س \(m) د" : "\(m) د"
        } else {
            return h > 0 ? "\(h)h \(m)m" : "\(m)m"
        }
    }

    // MARK: - Settings
    static var settings: String {
        lang == .arabic ? "الإعدادات" : "Settings"
    }
    static func intervalLabel(_ n: Int) -> String {
        lang == .arabic ? "الفاصل: \(n) د" : "Interval: \(n)m"
    }
    static var sound: String {
        lang == .arabic ? "صوت التنبيه" : "Alert sound"
    }
    static var autoStart: String {
        lang == .arabic ? "تشغيل مع النظام" : "Start at login"
    }
    static var language: String {
        lang == .arabic ? "اللغة" : "Language"
    }
    static var quit: String {
        lang == .arabic ? "إنهاء" : "Quit"
    }
    static var updateAvailable: String {
        lang == .arabic ? "تحديث متوفر!" : "Update available!"
    }
    static var download: String {
        lang == .arabic ? "تحميل" : "Download"
    }
    static func version(_ v: String) -> String {
        lang == .arabic ? "النسخة \(v)" : "Version \(v)"
    }
    static var checkForUpdates: String {
        lang == .arabic ? "تحقق من التحديثات" : "Check for updates"
    }
    static var upToDate: String {
        lang == .arabic ? "أنت على آخر نسخة" : "You're up to date"
    }
    static var interval: String {
        lang == .arabic ? "الفاصل" : "Interval"
    }
    static var intervalDuration: String {
        lang == .arabic ? "مدة الفاصل" : "Interval Duration"
    }
    static var minuteUnit: String {
        lang == .arabic ? "د" : "m"
    }

    // MARK: - Overlay
    static var overlayTitle: String {
        lang == .arabic ? "وقت راحة العيون" : "Time for an eye break"
    }
    static var overlaySubtitle: String {
        lang == .arabic ? "انظر لشيء يبعد عنك ٦ أمتار" : "Look at something 20 feet away"
    }
    static var overlayHint: String {
        lang == .arabic ? "بترجع تلقائياً..." : "Will return automatically..."
    }
    static var pressEscToSkip: String {
        lang == .arabic ? "اضغط ESC للتخطي" : "Press ESC to skip"
    }

    // MARK: - Notifications
    static var notifTitle: String {
        lang == .arabic ? "وقت راحة العيون 👁️" : "Eye Break Time 👁️"
    }
    static var notifBody: String {
        lang == .arabic ? "انظر لشيء يبعد عنك ٦ أمتار لمدة ٢٠ ثانية" : "Look at something 20 feet away for 20 seconds"
    }

    // MARK: - Pro
    static var upgradeToPro: String {
        lang == .arabic ? "الترقية لـ Pro" : "Upgrade to Pro"
    }
    static var proFeatures: String {
        lang == .arabic ? "إحصائيات • أصوات مخصصة • تقارير" : "Stats • Custom sounds • Reports"
    }
}

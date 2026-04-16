import Foundation
import AppKit
import Combine

@MainActor
final class TimerManager: ObservableObject {
    @Published var remainingSeconds: Int = 0
    @Published var isRunning = false
    @Published var isPaused = false
    @Published var isOnBreak = false
    @Published var breakRemainingSeconds: Int = 20
    @Published var breaksTakenToday: Int = 0
    @Published var screenTimeToday: TimeInterval = 0

    var onBreakTriggered: (() -> Void)?

    private var timer: Timer?
    private var targetFireDate: Date?
    private var screenTimeStartedAt: Date?
    private var settings: SettingsManager
    private var cancellable: AnyCancellable?

    private var demoMode: Bool {
        CommandLine.arguments.contains("--demo")
    }

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    private var todayString: String {
        Self.dayFormatter.string(from: Date())
    }

    init(settings: SettingsManager) {
        self.settings = settings
        loadDailyStats()
        observeIntervalChange()
    }

    private func observeIntervalChange() {
        cancellable = settings.$intervalMinutes
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self, self.isRunning, !self.isPaused, !self.isOnBreak else { return }
                self.resetInterval()
            }
    }

    func start() {
        let interval = currentInterval
        targetFireDate = Date().addingTimeInterval(interval)
        remainingSeconds = Int(interval)
        isRunning = true
        isPaused = false
        screenTimeStartedAt = Date()
        startTimer()
    }

    func pause() {
        isPaused = true
        timer?.invalidate()
        timer = nil
        accumulateScreenTime()
    }

    func resume() {
        guard isPaused else { return }
        isPaused = false
        if let target = targetFireDate {
            if target.timeIntervalSinceNow <= 0 {
                triggerBreak()
                return
            }
        }
        screenTimeStartedAt = Date()
        startTimer()
    }

    func snooze(minutes: Int) {
        if isOnBreak { endBreak() }
        targetFireDate = Date().addingTimeInterval(TimeInterval(minutes * 60))
        remainingSeconds = minutes * 60
        isPaused = false
        isRunning = true
        startTimer()
    }

    func skipBreak() {
        endBreak()
        resetInterval()
    }

    func triggerBreak() {
        timer?.invalidate()
        timer = nil
        isOnBreak = true
        breakRemainingSeconds = 20

        if settings.soundEnabled {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/afplay")
            process.arguments = ["/System/Library/Sounds/Blow.aiff"]
            try? process.run()
        }

        onBreakTriggered?()
        startBreakCountdown()
    }

    // MARK: - Private

    private var currentInterval: TimeInterval {
        demoMode ? 10 : TimeInterval(settings.intervalMinutes * 60)
    }

    private func startTimer() {
        timer?.invalidate()
        let t = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func tick() {
        checkDayChange()
        updateScreenTime()

        guard let target = targetFireDate else { return }
        let remaining = Int(target.timeIntervalSinceNow)

        if remaining <= 0 {
            remainingSeconds = 0
            triggerBreak()
        } else {
            remainingSeconds = remaining
        }
    }

    private func startBreakCountdown() {
        timer?.invalidate()
        let t = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.breakTick()
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }

    private func breakTick() {
        breakRemainingSeconds -= 1
        if breakRemainingSeconds <= 0 {
            endBreak()
            resetInterval()
        }
    }

    private func endBreak() {
        isOnBreak = false
        timer?.invalidate()
        timer = nil
        breaksTakenToday += 1
        settings.breaksTakenToday = breaksTakenToday
    }

    private func resetInterval() {
        let interval = currentInterval
        targetFireDate = Date().addingTimeInterval(interval)
        remainingSeconds = Int(interval)
        isRunning = true
        isPaused = false
        startTimer()
    }

    private func accumulateScreenTime() {
        if let start = screenTimeStartedAt {
            settings.screenTimeAccumulated += Date().timeIntervalSince(start)
            screenTimeStartedAt = nil
        }
    }

    private func updateScreenTime() {
        if let start = screenTimeStartedAt {
            screenTimeToday = settings.screenTimeAccumulated + Date().timeIntervalSince(start)
        } else {
            screenTimeToday = settings.screenTimeAccumulated
        }
    }

    private func checkDayChange() {
        let today = todayString
        if settings.lastActiveDate != today {
            settings.lastActiveDate = today
            settings.breaksTakenToday = 0
            settings.screenTimeAccumulated = 0
            breaksTakenToday = 0
            screenTimeToday = 0
            screenTimeStartedAt = Date()
        }
    }

    private func loadDailyStats() {
        let today = todayString
        if settings.lastActiveDate == today {
            breaksTakenToday = settings.breaksTakenToday
        } else {
            settings.lastActiveDate = today
            settings.breaksTakenToday = 0
            settings.screenTimeAccumulated = 0
        }
    }
}

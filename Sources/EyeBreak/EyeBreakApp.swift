import SwiftUI

@main
struct EyeBreakApp: App {
    @StateObject private var settings = SettingsManager()
    @StateObject private var notifications = NotificationManager()
    @StateObject private var updater = UpdateManager()
    @State private var timer: TimerManager?

    var body: some Scene {
        MenuBarExtra {
            if let timer {
                MenuBarView()
                    .environmentObject(timer)
                    .environmentObject(settings)
                    .environmentObject(updater)
            } else {
                ProgressView()
                    .onAppear { setupTimer() }
            }
        } label: {
            Image(systemName: menuBarIcon)
        }
        .menuBarExtraStyle(.window)
    }

    private var menuBarIcon: String {
        guard let timer else { return "eye" }
        if timer.isOnBreak { return "eye.trianglebadge.exclamationmark" }
        if timer.isPaused { return "eye.slash" }
        return "eye"
    }

    private func setupTimer() {
        let tm = TimerManager(settings: settings)
        var breakTask: Task<Void, Never>?

        tm.onBreakTriggered = { [notifications] in
            notifications.sendBreakNotification()
            notifications.showOverlay {
                breakTask?.cancel()
                tm.skipBreak()
                notifications.dismissOverlay()
            }

            breakTask = Task { @MainActor in
                try? await Task.sleep(for: .seconds(21))
                guard !Task.isCancelled else { return }
                notifications.dismissOverlay()
            }
        }

        notifications.requestPermission()
        self.timer = tm
        tm.start()
        updater.checkForUpdates()
    }
}

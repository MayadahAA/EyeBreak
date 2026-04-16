import Foundation
import UserNotifications

@MainActor
final class NotificationManager: NSObject, ObservableObject {
    let overlay = BreakOverlayWindow()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        UNUserNotificationCenter.current().delegate = self
    }

    func sendBreakNotification() {
        let content = UNMutableNotificationContent()
        content.title = L10n.notifTitle
        content.body = L10n.notifBody
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "eyebreak-\(Date().timeIntervalSince1970)",
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
    }

    func showOverlay(onSkip: @escaping () -> Void) {
        overlay.show(breakSeconds: 20, onSkip: onSkip)
    }

    func dismissOverlay() {
        overlay.dismiss()
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}

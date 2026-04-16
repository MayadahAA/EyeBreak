import Foundation
import AppKit

@MainActor
final class UpdateManager: ObservableObject {
    @Published var updateAvailable = false
    @Published var latestVersion = ""
    @Published var downloadURL = ""

    static let currentVersion = "1.0"

    private let owner = "MayadahAA"
    private let repo = "EyeBreak"
    private let checkIntervalHours = 24.0
    private let lastCheckKey = "eyebreak.lastUpdateCheck"

    func checkForUpdates(force: Bool = false) {
        if !force {
            let lastCheck = UserDefaults.standard.double(forKey: lastCheckKey)
            let hoursSinceLastCheck = (Date().timeIntervalSince1970 - lastCheck) / 3600
            if hoursSinceLastCheck < checkIntervalHours { return }
        }

        let urlString = "https://api.github.com/repos/\(owner)/\(repo)/releases/latest"
        guard let url = URL(string: urlString) else { return }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let tagName = json["tag_name"] as? String else { return }

                let latest = tagName.replacingOccurrences(of: "v", with: "")

                UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastCheckKey)

                if isNewer(latest, than: Self.currentVersion) {
                    self.latestVersion = latest
                    if let assets = json["assets"] as? [[String: Any]],
                       let dmg = assets.first(where: { ($0["name"] as? String)?.hasSuffix(".dmg") == true }),
                       let url = dmg["browser_download_url"] as? String {
                        self.downloadURL = url
                    }
                    self.updateAvailable = true
                }
            } catch {
                print("Update check failed: \(error)")
            }
        }
    }

    func openDownloadPage() {
        let urlString = downloadURL.isEmpty
            ? "https://github.com/\(owner)/\(repo)/releases/latest"
            : downloadURL
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }

    private func isNewer(_ remote: String, than local: String) -> Bool {
        let r = remote.split(separator: ".").compactMap { Int($0) }
        let l = local.split(separator: ".").compactMap { Int($0) }
        for i in 0..<max(r.count, l.count) {
            let rv = i < r.count ? r[i] : 0
            let lv = i < l.count ? l[i] : 0
            if rv > lv { return true }
            if rv < lv { return false }
        }
        return false
    }
}

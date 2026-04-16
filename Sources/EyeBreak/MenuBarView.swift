import SwiftUI

struct MenuBarView: View {
    @EnvironmentObject var timer: TimerManager
    @EnvironmentObject var settings: SettingsManager
    @EnvironmentObject var updater: UpdateManager
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 14) {
            if updater.updateAvailable {
                updateBanner
            }
            header
            timerCard
            stats
            settingsSection
            quitButton
        }
        .padding(16)
        .frame(width: 280)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Image(systemName: "eye.circle.fill")
                .font(.title2)
                .foregroundStyle(.teal)
            Text(L10n.appName)
                .font(.headline)
            Spacer()
            statusBadge
        }
    }

    private var statusBadge: some View {
        Group {
            if timer.isOnBreak {
                Label(L10n.statusBreak, systemImage: "pause.fill")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.orange, in: Capsule())
                    .foregroundStyle(.black)
            } else if timer.isPaused {
                Label(L10n.statusPaused, systemImage: "moon.fill")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.secondary.opacity(0.3), in: Capsule())
                    .foregroundStyle(.primary)
            } else if timer.isRunning {
                Label(L10n.statusRunning, systemImage: "checkmark.circle.fill")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.green.opacity(0.2), in: Capsule())
                    .foregroundStyle(.green)
            }
        }
    }

    // MARK: - Timer Card

    private var timerCard: some View {
        GroupBox {
            VStack(spacing: 10) {
                if timer.isOnBreak {
                    VStack(spacing: 6) {
                        Text(L10n.lookAway)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("\(timer.breakRemainingSeconds)")
                            .font(.system(size: 44, weight: .light, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(.orange)
                        Text(L10n.seconds)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } else if !timer.isRunning {
                    VStack(spacing: 8) {
                        Image(systemName: "eye")
                            .font(.largeTitle)
                            .foregroundStyle(.teal.opacity(0.6))
                        Text(L10n.readyToStart)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    VStack(spacing: 4) {
                        Text(L10n.nextBreak)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(formatTime(timer.remainingSeconds))
                            .font(.system(size: 40, weight: .light, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(timer.isPaused ? .secondary : .primary)
                    }
                }

                controls
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
    }

    // MARK: - Controls

    private var controls: some View {
        HStack(spacing: 10) {
            if timer.isOnBreak {
                Button {
                    timer.skipBreak()
                } label: {
                    Label(L10n.skip, systemImage: "forward.end")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
            } else if !timer.isRunning {
                Button {
                    timer.start()
                } label: {
                    Label(L10n.start, systemImage: "play.fill")
                        .font(.caption)
                }
                .buttonStyle(.borderedProminent)
                .tint(.teal)
            } else {
                if timer.isPaused {
                    Button {
                        timer.resume()
                    } label: {
                        Label(L10n.resume, systemImage: "play.fill")
                            .font(.caption)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.teal)
                } else {
                    Button {
                        timer.pause()
                    } label: {
                        Label(L10n.pause, systemImage: "pause.fill")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                }

                Menu {
                    Button(L10n.minutes(5)) { timer.snooze(minutes: 5) }
                    Button(L10n.minutes(10)) { timer.snooze(minutes: 10) }
                    Button(L10n.minutes(15)) { timer.snooze(minutes: 15) }
                } label: {
                    Label(L10n.snooze, systemImage: "moon.zzz")
                        .font(.caption)
                }
                .menuStyle(.borderlessButton)
            }
        }
    }

    // MARK: - Stats

    private var stats: some View {
        HStack(spacing: 16) {
            statItem(
                icon: "checkmark.circle.fill",
                color: .green,
                value: "\(timer.breaksTakenToday)",
                label: L10n.breaks
            )
            statItem(
                icon: "clock.fill",
                color: .teal,
                value: formatScreenTime(timer.screenTimeToday),
                label: L10n.screenTime
            )
        }
    }

    private func statItem(icon: String, color: Color, value: String, label: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.caption)
            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(label)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Settings

    private var settingsSection: some View {
        DisclosureGroup(L10n.settings, isExpanded: $showSettings) {
            VStack(spacing: 10) {
                Stepper(
                    L10n.intervalLabel(settings.intervalMinutes),
                    value: $settings.intervalMinutes,
                    in: 5...60,
                    step: 5
                )
                .font(.caption)

                Toggle(L10n.sound, isOn: $settings.soundEnabled)
                    .font(.caption)

                Toggle(L10n.autoStart, isOn: $settings.autoStartOnLogin)
                    .font(.caption)

                Picker(L10n.language, selection: $settings.appLanguage) {
                    ForEach(AppLanguage.allCases, id: \.self) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
                .font(.caption)

                Button {
                    updater.checkForUpdates(force: true)
                } label: {
                    Label(L10n.checkForUpdates, systemImage: "arrow.clockwise")
                        .font(.caption)
                }
            }
            .padding(.top, 6)
        }
        .font(.caption)
    }

    // MARK: - Update Banner

    private var updateBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.down.circle.fill")
                .foregroundStyle(.teal)
            VStack(alignment: .leading, spacing: 1) {
                Text(L10n.updateAvailable)
                    .font(.caption)
                    .fontWeight(.medium)
                Text(L10n.version(updater.latestVersion))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(L10n.download) {
                updater.openDownloadPage()
            }
            .buttonStyle(.borderedProminent)
            .tint(.teal)
            .controlSize(.small)
        }
        .padding(10)
        .background(.teal.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Quit

    private var quitButton: some View {
        Button {
            NSApp.terminate(nil)
        } label: {
            Text(L10n.quit)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    // MARK: - Helpers

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    private func formatScreenTime(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        return L10n.hoursMinutes(hours, minutes)
    }
}

import SwiftUI

// MARK: - Design Tokens (matches Claude Design prototype)

private struct Accent {
    static let main = Color(red: 0.31, green: 0.63, blue: 0.82)       // oklch(68% 0.14 208)
    static let dark = Color(red: 0.10, green: 0.18, blue: 0.24)       // oklch(25% 0.06 208)
    static let glow = Color(red: 0.31, green: 0.63, blue: 0.82, opacity: 0.15)
    static let softGlow = Color(red: 0.31, green: 0.63, blue: 0.82, opacity: 0.08)
}

private let bgGradient = LinearGradient(
    colors: [
        Color(red: 0.055, green: 0.094, blue: 0.141),  // #0e1824
        Color(red: 0.039, green: 0.063, blue: 0.094),  // #0a1018
        Color(red: 0.024, green: 0.047, blue: 0.071)   // #060c12
    ],
    startPoint: .top,
    endPoint: .bottom
)

// MARK: - Menu Bar View

struct MenuBarView: View {
    @EnvironmentObject var timer: TimerManager
    @EnvironmentObject var settings: SettingsManager
    @EnvironmentObject var updater: UpdateManager
    @State private var breatheIcon = false

    var body: some View {
        ZStack(alignment: .top) {
            bgGradient

            // Ambient top glow
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Accent.main.opacity(0.12), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 160)
                .blur(radius: 30)
                .offset(y: -40)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                if updater.updateAvailable { updateBanner.padding([.horizontal, .top], 16) }
                header
                arcTimer
                controls
                stats
                settingsDrawer
                quitButton
            }
        }
        .frame(width: 320)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Accent.softGlow, lineWidth: 1)
        )
        .onAppear { breatheIcon = true }
    }

    // MARK: Header

    private var header: some View {
        HStack {
            HStack(spacing: 8) {
                EyeIcon()
                    .opacity(breatheIcon ? 1 : 0.5)
                    .scaleEffect(breatheIcon ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: breatheIcon)
                Text(L10n.appName)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                    .tracking(-0.3)
            }
            Spacer()
            statusBadge
        }
        .padding(.horizontal, 22)
        .padding(.top, 18)
    }

    private var statusBadge: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(Accent.main)
                .frame(width: 5, height: 5)
                .shadow(color: Accent.main, radius: 3)
                .opacity(timer.isRunning && !timer.isPaused ? (breatheIcon ? 1 : 0.5) : 0.4)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: breatheIcon)
            Text(timer.isRunning && !timer.isPaused ? L10n.statusRunning : L10n.statusPaused)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Accent.main)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(Accent.dark, in: Capsule())
    }

    // MARK: Arc Timer

    private var arcTimer: some View {
        let total = max(timer.currentCycleSeconds, 1)
        let rawProgress = 1 - (Double(timer.remainingSeconds) / Double(total))
        let progress = min(max(rawProgress, 0.0), 1.0)

        return ZStack {
            ArcProgress(progress: progress, color: Accent.main)
                .frame(height: 170)
                .padding(.horizontal, 10)

            VStack(spacing: 8) {
                Text(L10n.nextBreak)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.white.opacity(0.25))
                    .tracking(2)

                Text(formatTime(timer.remainingSeconds))
                    .font(.system(size: 54, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .tracking(-2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Accent.main],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .offset(y: 20)
        }
        .padding(.top, 20)
    }

    // MARK: Controls

    private var controls: some View {
        HStack(spacing: 14) {
            // Play / Pause
            Button {
                if !timer.isRunning {
                    timer.start()
                } else if timer.isPaused {
                    timer.resume()
                } else {
                    timer.pause()
                }
            } label: {
                let playing = timer.isRunning && !timer.isPaused
                Image(systemName: playing ? "pause.fill" : "play.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(playing ? .white : Color(red: 0.024, green: 0.047, blue: 0.071))
                    .frame(width: 58, height: 58)
                    .background(
                        Circle()
                            .fill(playing ? Color.white.opacity(0.06) : Accent.main)
                    )
                    .shadow(color: !playing ? Accent.main.opacity(0.35) : .clear, radius: 12)
            }
            .buttonStyle(.plain)

            // Snooze
            Button {
                timer.snooze(minutes: 5)
            } label: {
                Text("💤")
                    .font(.system(size: 18))
                    .frame(width: 58, height: 58)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.02))
                            .overlay(Circle().stroke(Color.white.opacity(0.06), lineWidth: 1))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 14)
    }

    // MARK: Stats

    private var stats: some View {
        HStack(spacing: 0) {
            statCell(value: "\(Int(timer.screenTimeToday / 60))", unit: L10n.minuteUnit, label: L10n.screenTime, color: .white)
            divider
            statCell(value: "\(timer.breaksTakenToday)", unit: "", label: L10n.breaks, color: Accent.main)
            divider
            statCell(value: "\(settings.intervalMinutes)", unit: L10n.minuteUnit, label: L10n.interval, color: .white)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .overlay(alignment: .top) {
            Rectangle().fill(Color.white.opacity(0.04)).frame(height: 1).padding(.top, 24).padding(.horizontal, 24)
        }
        .overlay(alignment: .bottom) {
            Rectangle().fill(Color.white.opacity(0.04)).frame(height: 1).padding(.horizontal, 24)
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.04))
            .frame(width: 1, height: 40)
    }

    private func statCell(value: String, unit: String, label: String, color: Color) -> some View {
        VStack(spacing: 3) {
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 22, weight: .semibold, design: .monospaced))
                    .foregroundStyle(color)
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 11))
                        .foregroundStyle(.white.opacity(0.25))
                }
            }
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.white.opacity(0.2))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    // MARK: Settings (always visible)

    private var settingsDrawer: some View {
        VStack(spacing: 0) {
            HStack {
                Text(L10n.settings)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.35))
                    .tracking(1)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 10)

            VStack(spacing: 14) {
                intervalSelector
                togglesRow
                languageSelector
                updateCheckButton
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }

    private var intervalSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.intervalDuration)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.white.opacity(0.25))
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 6) {
                ForEach([10, 15, 20, 30, 45, 60], id: \.self) { v in
                    pillButton(value: "\(v)\(L10n.minuteUnit)", selected: settings.intervalMinutes == v) {
                        settings.intervalMinutes = v
                    }
                }
            }
        }
    }

    private func pillButton(value: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(selected ? Accent.main : .white.opacity(0.3))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(selected ? Accent.dark : Color.white.opacity(0.02), in: RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(selected ? Accent.main.opacity(0.3) : Color.white.opacity(0.04), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private var togglesRow: some View {
        HStack(spacing: 10) {
            toggleCell(label: L10n.sound, on: settings.soundEnabled) {
                settings.soundEnabled.toggle()
            }
            toggleCell(label: L10n.autoStart, on: settings.autoStartOnLogin) {
                settings.autoStartOnLogin.toggle()
            }
        }
    }

    private func toggleCell(label: String, on: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Circle()
                    .fill(on ? Accent.main : Color.white.opacity(0.15))
                    .frame(width: 6, height: 6)
                    .shadow(color: on ? Accent.main.opacity(0.4) : .clear, radius: 3)
                Text(label)
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(on ? Accent.main : .white.opacity(0.25))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(on ? Accent.dark : Color.white.opacity(0.02), in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(on ? Accent.main.opacity(0.25) : Color.white.opacity(0.04), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var languageSelector: some View {
        HStack(spacing: 6) {
            ForEach(AppLanguage.allCases, id: \.self) { lang in
                pillButton(
                    value: lang.displayName,
                    selected: settings.appLanguage == lang
                ) {
                    settings.appLanguage = lang
                }
            }
        }
    }

    private var updateCheckButton: some View {
        Button {
            updater.checkForUpdates(force: true)
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 10))
                Text(L10n.checkForUpdates)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundStyle(.white.opacity(0.3))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.02), in: RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.04), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: Update Banner

    private var updateBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.down.circle.fill")
                .foregroundStyle(Accent.main)
            VStack(alignment: .leading, spacing: 1) {
                Text(L10n.updateAvailable)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                Text(L10n.version(updater.latestVersion))
                    .font(.system(size: 10))
                    .foregroundStyle(.white.opacity(0.5))
            }
            Spacer()
            Button(L10n.download) {
                updater.openDownloadPage()
            }
            .buttonStyle(.borderedProminent)
            .tint(Accent.main)
            .controlSize(.small)
        }
        .padding(10)
        .background(Accent.main.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: Quit

    private var quitButton: some View {
        Button {
            NSApp.terminate(nil)
        } label: {
            Text(L10n.quit)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.15))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
        }
        .buttonStyle(.plain)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.white.opacity(0.03))
                .frame(height: 1)
        }
    }

    // MARK: Helpers

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}

// MARK: - Eye Icon

private struct EyeIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Accent.dark)
                .overlay(Circle().stroke(Accent.main, lineWidth: 1.2))
                .frame(width: 22, height: 22)
            Circle()
                .fill(Accent.main)
                .frame(width: 10, height: 10)
            Circle()
                .fill(Color(red: 0.024, green: 0.047, blue: 0.071))
                .frame(width: 4, height: 4)
        }
    }
}

// MARK: - Arc Progress

private struct ArcProgress: View {
    let progress: Double
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let centerX = w / 2
            let bottomY = h * 0.91
            let radius = min(w * 0.42, h * 0.8)

            ZStack {
                // Track
                Path { p in
                    p.addArc(
                        center: CGPoint(x: centerX, y: bottomY),
                        radius: radius,
                        startAngle: .degrees(180),
                        endAngle: .degrees(360),
                        clockwise: false
                    )
                }
                .stroke(color.opacity(0.08), style: StrokeStyle(lineWidth: 3.5, lineCap: .round))

                // Progress
                Path { p in
                    p.addArc(
                        center: CGPoint(x: centerX, y: bottomY),
                        radius: radius,
                        startAngle: .degrees(180),
                        endAngle: .degrees(180 + 180 * progress),
                        clockwise: false
                    )
                }
                .stroke(color, style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
                .shadow(color: color.opacity(0.5), radius: 4)
                .animation(.linear(duration: 1), value: progress)

                // Progress dot
                let angle = Angle.degrees(180 + 180 * progress)
                let dotX = centerX + radius * cos(CGFloat(angle.radians))
                let dotY = bottomY + radius * sin(CGFloat(angle.radians))

                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                    .shadow(color: color, radius: 5)
                    .position(x: dotX, y: dotY)
                    .animation(.linear(duration: 1), value: progress)

                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 1)
                    .frame(width: 20, height: 20)
                    .position(x: dotX, y: dotY)
                    .animation(.linear(duration: 1), value: progress)

                // Tick marks
                ForEach(0..<5, id: \.self) { i in
                    let p = Double(i) * 0.25
                    let a = Angle.degrees(180 + 180 * p)
                    let x1 = centerX + radius * cos(CGFloat(a.radians))
                    let y1 = bottomY + radius * sin(CGFloat(a.radians))
                    let x2 = centerX + (radius + 8) * cos(CGFloat(a.radians))
                    let y2 = bottomY + (radius + 8) * sin(CGFloat(a.radians))
                    Path { path in
                        path.move(to: CGPoint(x: x1, y: y1))
                        path.addLine(to: CGPoint(x: x2, y: y2))
                    }
                    .stroke(Color.white.opacity(0.08), lineWidth: 1.5)
                }
            }
        }
    }
}

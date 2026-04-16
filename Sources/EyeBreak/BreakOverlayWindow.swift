import AppKit
import SwiftUI

final class BreakOverlayWindow {
    private var panel: NSPanel?
    private var eventMonitor: Any?

    func show(breakSeconds: Int, onSkip: @escaping () -> Void) {
        guard let screen = NSScreen.main else { return }

        let panel = NSPanel(
            contentRect: screen.frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.level = .screenSaver
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.backgroundColor = .black
        panel.isOpaque = true
        panel.hasShadow = false

        let overlayView = BreakOverlayView(onSkip: onSkip)
        panel.contentView = NSHostingView(rootView: overlayView)

        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 53 { // ESC
                onSkip()
                return nil
            }
            return event
        }

        panel.orderFrontRegardless()
        self.panel = panel
    }

    func dismiss() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
        panel?.close()
        panel = nil
    }
}

// MARK: - TV Static Overlay

struct BreakOverlayView: View {
    var onSkip: () -> Void

    @State private var noisePhase = 0
    @State private var timer: Timer?

    private let pixelSize = 8

    var body: some View {
        ZStack {
            Canvas { context, size in
                let cols = Int(size.width / CGFloat(pixelSize))
                let rows = Int(size.height / CGFloat(pixelSize))
                for row in 0..<rows {
                    for col in 0..<cols {
                        let brightness = Double.random(in: 0.03...0.15)
                        let rect = CGRect(
                            x: col * pixelSize, y: row * pixelSize,
                            width: pixelSize, height: pixelSize
                        )
                        context.fill(Path(rect), with: .color(.white.opacity(brightness)))
                    }
                }
            }
            .id(noisePhase)

            // Scanlines
            Canvas { context, size in
                for y in stride(from: 0, to: size.height, by: 4) {
                    let rect = CGRect(x: 0, y: y, width: size.width, height: 1)
                    context.fill(Path(rect), with: .color(.black.opacity(0.3)))
                }
            }

            // Skip hint
            VStack {
                Spacer()
                Button {
                    timer?.invalidate()
                    onSkip()
                } label: {
                    Text(L10n.pressEscToSkip)
                        .font(.system(size: 13, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.25))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { startNoise() }
        .onDisappear { timer?.invalidate() }
    }

    private func startNoise() {
        let t = Timer(timeInterval: 0.3, repeats: true) { _ in
            DispatchQueue.main.async {
                noisePhase += 1
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }
}

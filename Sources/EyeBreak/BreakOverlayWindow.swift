import AppKit
import SwiftUI
import CoreGraphics

// Custom panel that can become key window so it receives keyboard events
private final class KeyablePanel: NSPanel {
    var onEscape: (() -> Void)?

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
    override var acceptsFirstResponder: Bool { true }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 {  // ESC
            onEscape?()
        } else {
            super.keyDown(with: event)
        }
    }
}

final class BreakOverlayWindow {
    private var panel: KeyablePanel?

    func show(breakSeconds: Int, onSkip: @escaping () -> Void) {
        guard let screen = NSScreen.main else { return }

        let panel = KeyablePanel(
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
        panel.onEscape = onSkip

        let overlayView = BreakOverlayView(onSkip: onSkip)
        panel.contentView = NSHostingView(rootView: overlayView)

        panel.makeKeyAndOrderFront(nil)
        self.panel = panel
    }

    func dismiss() {
        panel?.onEscape = nil
        panel?.close()
        panel = nil
    }
}

// MARK: - Noise Image Generator

private func generateNoiseImage(width: Int, height: Int) -> CGImage? {
    let scale = 2  // render at half resolution then stretch — fine grain + good perf
    let w = width / scale
    let h = height / scale
    let count = w * h

    var pixels = [UInt8](repeating: 0, count: count)
    for i in 0..<count {
        pixels[i] = UInt8.random(in: 6...42)  // dark gray, near-black
    }

    let colorSpace = CGColorSpaceCreateDeviceGray()
    guard let provider = CGDataProvider(data: Data(pixels) as CFData) else { return nil }

    return CGImage(
        width: w,
        height: h,
        bitsPerComponent: 8,
        bitsPerPixel: 8,
        bytesPerRow: w,
        space: colorSpace,
        bitmapInfo: CGBitmapInfo(rawValue: 0),
        provider: provider,
        decode: nil,
        shouldInterpolate: false,
        intent: .defaultIntent
    )
}

// MARK: - SwiftUI Overlay View

struct BreakOverlayView: View {
    var onSkip: () -> Void

    @State private var noiseImage: CGImage?
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            if let noiseImage {
                Image(decorative: noiseImage, scale: 1)
                    .resizable()
                    .interpolation(.none)
                    .ignoresSafeArea()
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
                        .foregroundStyle(.white.opacity(0.2))
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
        let screen = NSScreen.main ?? NSScreen.screens[0]
        let w = Int(screen.frame.width)
        let h = Int(screen.frame.height)

        noiseImage = generateNoiseImage(width: w, height: h)

        let t = Timer(timeInterval: 0.12, repeats: true) { _ in
            DispatchQueue.main.async {
                noiseImage = generateNoiseImage(width: w, height: h)
            }
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }
}

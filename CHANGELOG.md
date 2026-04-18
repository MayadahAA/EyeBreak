# Changelog

All notable changes to EyeBreak will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned
- Pro features: weekly statistics, custom sounds, Pomodoro mode
- Homebrew Cask distribution
- Apple Notarization for no security warnings

---

## [1.0.0] — 2026-04-18

### 🎉 Initial Public Release

#### Added
- **Menu bar app** with SwiftUI popover showing arc progress timer
- **20-20-20 reminders** — configurable interval from 5 to 60 minutes
- **TV static break overlay** — anti-attention design (dark grayscale noise)
- **Timer controls**: start, pause, resume, snooze, skip
- **Daily stats**: breaks taken + screen time (auto-resets at midnight)
- **Auto-start on login** via `SMAppService`
- **Bilingual UI** (Arabic + English) with system language auto-detection
- **Auto-update checker** querying GitHub Releases API
- **Keyboard shortcut**: `ESC` to skip active break
- **Persistent settings** via `UserDefaults`

#### Technical
- Swift 5.9 + SwiftUI + AppKit
- Uses `NSPanel` with `.screenSaver` level for overlay (covers full-screen apps)
- Timer uses `targetFireDate` (absolute time) — survives Mac sleep/wake
- `CGImage` pixel-based noise renderer (50× faster than Canvas rects)
- Zero external dependencies

#### Distribution
- DMG (~380 KB) with ad-hoc code signing
- Landing page (GitHub Pages)
- MIT licensed

---

[Unreleased]: https://github.com/MayadahAA/EyeBreak/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/MayadahAA/EyeBreak/releases/tag/v1.0.0

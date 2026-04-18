<div align="center">

# EyeBreak 👁️

### Your eyes deserve a break.

**Smart 20-20-20 reminders for macOS. Lives in your menu bar. Triggers TV static when it's time to rest.**

[![Download](https://img.shields.io/badge/Download-macOS-2dd4bf?style=for-the-badge&logo=apple)](https://github.com/MayadahAA/EyeBreak/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](./LICENSE)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg?style=for-the-badge&logo=swift)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-macOS%2013%2B-lightgrey.svg?style=for-the-badge)](https://developer.apple.com/macos/)
[![Product Hunt](https://img.shields.io/badge/Product%20Hunt-Launched-da552f.svg?style=for-the-badge&logo=producthunt)](https://producthunt.com)

[**Download**](https://github.com/MayadahAA/EyeBreak/releases/latest) · [**Website**](https://mayadahaa.github.io/EyeBreak/) · [**Report Bug**](https://github.com/MayadahAA/EyeBreak/issues/new?template=bug_report.md) · [**Request Feature**](https://github.com/MayadahAA/EyeBreak/issues/new?template=feature_request.md)

<img src="docs/screenshots/hero.png" alt="EyeBreak Hero" width="600"/>

</div>

---

## Why EyeBreak?

Staring at screens all day causes **digital eye strain** — headaches, dry eyes, blurred vision. The **20-20-20 rule** (every 20 min, look 20 feet away for 20 seconds) is clinically proven to help, but reminders are easy to dismiss.

**EyeBreak takes a different approach:** when break time comes, your screen fills with TV static. No countdown to stare at, no pretty animation. Just a boring screen that makes you look away *naturally*.

---

## Features

<table>
<tr>
<td width="50%">

### 🆓 Free Forever
- ✅ Smart 20-20-20 reminders
- ✅ TV static break overlay
- ✅ Menu bar timer with arc progress
- ✅ Pause, snooze, skip controls
- ✅ Auto-start on login
- ✅ Arabic + English (auto-detect)
- ✅ Auto-update from GitHub
- ✅ ~100 KB, zero dependencies

</td>
<td width="50%">

### ⭐ Pro (Coming Soon)
- 📊 Weekly statistics & charts
- 🔊 Custom alert sounds
- 🎨 Overlay customization
- 🍅 Pomodoro mode
- 📅 Monthly PDF reports
- 💰 One-time $4.99 (no subscription)

</td>
</tr>
</table>

---

## Screenshots

<div align="center">

| Menu Bar | Settings | Break Overlay |
|:---:|:---:|:---:|
| <img src="docs/screenshots/menu-bar.png" width="250"/> | <img src="docs/screenshots/settings.png" width="250"/> | <img src="docs/screenshots/overlay.png" width="250"/> |

</div>

---

## Installation

### Option 1: Download DMG (recommended)

1. [**Download the latest DMG**](https://github.com/MayadahAA/EyeBreak/releases/latest/download/EyeBreak-1.0.dmg)
2. Open the DMG and drag **EyeBreak** to `/Applications`
3. Right-click the app → **Open** (first time only — due to macOS security)

### Option 2: Homebrew (coming soon)

```bash
brew install --cask eyebreak
```

### Option 3: Build from Source

```bash
git clone https://github.com/MayadahAA/EyeBreak.git
cd EyeBreak
make run
```

---

## Requirements

| Requirement | Version |
|---|---|
| macOS | 13 (Ventura) or later |
| Swift | 5.9+ (for building) |
| Disk | ~1 MB |

---

## Usage

1. **Launch** — an eye icon appears in your menu bar
2. **Click** to view the timer, stats, and settings
3. **Work normally** — EyeBreak runs quietly in the background
4. **Break time** — your screen fills with TV static for 20 seconds
5. **Press ESC** anytime to skip a break

---

## Architecture

EyeBreak uses an **Open Core** model. The free version in this repo is fully functional and open source. Pro features are distributed as signed DMG builds.

```
EyeBreak/
├── Sources/EyeBreak/       # Core app (free, open source)
│   ├── EyeBreakApp.swift           # Entry point
│   ├── TimerManager.swift          # Timer + stats engine
│   ├── SettingsManager.swift       # UserDefaults + login item
│   ├── NotificationManager.swift   # macOS notifications
│   ├── BreakOverlayWindow.swift    # TV static NSPanel
│   ├── MenuBarView.swift           # SwiftUI popover
│   ├── Strings.swift               # AR + EN localization
│   ├── ProManager.swift            # Pro stub (free build)
│   └── UpdateManager.swift         # GitHub Releases checker
├── Resources/Info.plist            # App bundle metadata
├── scripts/                        # Build + release tooling
├── website/                        # Landing page (GitHub Pages)
└── docs/                           # Documentation + screenshots
```

**Tech stack:** Swift 5.9 · SwiftUI · AppKit · UserNotifications · ServiceManagement · Combine · Swift Package Manager

**Zero external dependencies.**

---

## Development

```bash
# Build release
make

# Build + launch
make run

# Install to /Applications
make install

# Demo mode (10-second timer for testing)
open build/EyeBreak.app --args --demo

# Create distribution DMG
bash scripts/create-dmg.sh
```

---

## Roadmap

- [x] **v1.0** — Initial release: menu bar app, TV static, AR/EN
- [ ] **v1.1** — Pro features: weekly stats, custom sounds, Pomodoro
- [ ] **v1.2** — Homebrew Cask distribution
- [ ] **v1.3** — Apple Notarization (no security warnings)
- [ ] **v2.0** — iOS companion app (Shortcut integration)

See [CHANGELOG.md](./CHANGELOG.md) for version history.

---

## Contributing

Contributions welcome! Please read [CONTRIBUTING.md](./CONTRIBUTING.md) first.

**Quick guide:**
1. Fork the repo
2. Create a feature branch (`git checkout -b feat/amazing-feature`)
3. Commit (`git commit -m 'feat: add amazing feature'`)
4. Push (`git push origin feat/amazing-feature`)
5. Open a Pull Request

---

## Support

- **Found a bug?** [Open an issue](https://github.com/MayadahAA/EyeBreak/issues/new?template=bug_report.md)
- **Feature idea?** [Request it](https://github.com/MayadahAA/EyeBreak/issues/new?template=feature_request.md)
- **Like the project?** [Sponsor development](https://github.com/sponsors/MayadahAA) · [Star on GitHub](https://github.com/MayadahAA/EyeBreak)

---

## License

EyeBreak is released under the [MIT License](./LICENSE).

---

<div align="center">

**Built with ❤️ by [MayadahAA](https://github.com/MayadahAA)**

Made using [Claude Code](https://claude.com/claude-code) · Inspired by the [20-20-20 rule](https://www.aao.org/eye-health/tips-prevention/computer-usage)

</div>

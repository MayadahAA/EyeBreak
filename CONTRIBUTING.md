# Contributing to EyeBreak

Thanks for your interest in contributing! 🎉

## Ways to Contribute

- 🐛 **Report bugs** — [open an issue](https://github.com/MayadahAA/EyeBreak/issues/new?template=bug_report.md)
- 💡 **Suggest features** — [request a feature](https://github.com/MayadahAA/EyeBreak/issues/new?template=feature_request.md)
- 🌍 **Add translations** — currently Arabic + English, more welcome
- 📝 **Improve docs** — README, CONTRIBUTING, inline comments
- 🔧 **Fix bugs / add features** — pull requests welcome

---

## Development Setup

### Prerequisites
- macOS 13 (Ventura) or later
- Xcode Command Line Tools: `xcode-select --install`
- Swift 5.9+ (comes with Xcode 15)

### Build & Run
```bash
git clone https://github.com/MayadahAA/EyeBreak.git
cd EyeBreak
make run
```

### Demo Mode
Use a 10-second timer instead of 20 minutes (for testing breaks):
```bash
open build/EyeBreak.app --args --demo
```

---

## Pull Request Process

1. **Fork** the repo and create your branch from `main`:
   ```bash
   git checkout -b feat/amazing-feature
   ```

2. **Make your changes** — keep commits focused and atomic

3. **Test locally** — run `make` to verify no build errors

4. **Commit with conventional format**:
   ```
   feat: add Pomodoro mode
   fix: correct pause/resume time drift
   docs: update installation instructions
   refactor: extract TimerManager tick logic
   ```

5. **Push** your branch:
   ```bash
   git push origin feat/amazing-feature
   ```

6. **Open a Pull Request** — describe what changed and why

---

## Code Style

- **Swift**: follow [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
- **SwiftUI**: prefer `@StateObject` / `@EnvironmentObject` over singletons
- **Concurrency**: use `@MainActor` for UI-touching classes
- **Comments**: only when code isn't self-explanatory — prefer clear naming
- **Localization**: all user-facing strings go in `Strings.swift` (`L10n`)

---

## Translation Contributions

Want to add a new language?

1. Open `Sources/EyeBreak/Strings.swift`
2. Add your language to the `AppLanguage` enum
3. Add translations in the `L10n` enum for every string
4. Test: change system language or toggle via Settings
5. Submit PR

---

## Project Structure

See the [Architecture section in README](./README.md#architecture).

**Key files to understand first:**
- `EyeBreakApp.swift` — app entry, wires everything together
- `TimerManager.swift` — timer + stats logic (most complex file)
- `MenuBarView.swift` — main UI

---

## Code of Conduct

Be kind. Be constructive. We're building something small but useful — keep the vibe friendly.

---

## Questions?

Open an issue or ping [@MayadahAA](https://github.com/MayadahAA) on GitHub.

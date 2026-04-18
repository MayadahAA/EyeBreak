# Screenshots

Place screenshots here to be referenced in the main [README.md](../../README.md).

## Required Screenshots

| Filename | Description | Recommended Size |
|---|---|---|
| `hero.png` | Main banner image for README | 1200×600 |
| `menu-bar.png` | Menu bar popover showing timer | 800×600 |
| `settings.png` | Menu bar popover with settings visible | 800×600 |
| `overlay.png` | TV static break overlay | 1200×750 |
| `icon.png` | App icon / logo | 512×512 |

## How to Capture

### Menu bar popover
1. Click the eye icon in menu bar
2. Press `Cmd+Shift+4`, then `Space`, then click the popover
3. Save to this folder

### Break overlay
1. Run in demo mode: `open build/EyeBreak.app --args --demo`
2. Wait 10 seconds for break to trigger
3. Press `Cmd+Shift+3` for full screen capture

### Hero image
Design a 1200×600 banner in Figma or similar, showcasing the menu bar + product name.

## Optimization

Before committing, optimize PNG files:
```bash
# Install pngquant (one-time)
brew install pngquant

# Optimize all PNGs
pngquant --quality=65-80 --skip-if-larger --ext .png --force *.png
```

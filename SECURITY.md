# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.0.x   | ✅ |
| < 1.0   | ❌ |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, email: **d.mayadah@gmail.com** with subject: `[EyeBreak Security]`.

Include:
- Description of the issue
- Steps to reproduce
- Potential impact
- Any proposed fix

You'll get a response within **48 hours**. Fixes are prioritized based on severity.

## Scope

EyeBreak is a local macOS app with no server component. Main security concerns:
- Code signing bypass
- Auto-update man-in-the-middle (we use HTTPS to `api.github.com`)
- UserDefaults tampering

## Acknowledgments

Reporters of valid vulnerabilities will be credited in the release notes (unless they prefer anonymity).

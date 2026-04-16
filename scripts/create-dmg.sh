#!/bin/bash
# Create DMG for EyeBreak distribution
set -e

APP_NAME="EyeBreak"
VERSION="1.0"
DMG_NAME="${APP_NAME}-${VERSION}"
BUILD_DIR="build"
DMG_DIR="${BUILD_DIR}/dmg"
DMG_PATH="${BUILD_DIR}/${DMG_NAME}.dmg"

cd "$(dirname "$0")/.."

echo "🔨 Building release..."
make

echo "📦 Preparing DMG contents..."
rm -rf "$DMG_DIR"
mkdir -p "$DMG_DIR"
cp -R "${BUILD_DIR}/${APP_NAME}.app" "${DMG_DIR}/"
ln -s /Applications "${DMG_DIR}/Applications"

echo "💿 Creating DMG..."
rm -f "$DMG_PATH"
hdiutil create \
    -volname "$APP_NAME" \
    -srcfolder "$DMG_DIR" \
    -ov \
    -format UDZO \
    "$DMG_PATH"

rm -rf "$DMG_DIR"

echo ""
echo "✅ DMG created: ${DMG_PATH}"
echo "   Size: $(du -h "$DMG_PATH" | cut -f1)"
echo ""
echo "📝 For distribution with notarization:"
echo "   1. Sign:     codesign --force --sign 'Developer ID Application: YOUR_NAME' ${BUILD_DIR}/${APP_NAME}.app"
echo "   2. Rebuild:  Run this script again"
echo "   3. Notarize: xcrun notarytool submit ${DMG_PATH} --apple-id YOUR_APPLE_ID --team-id YOUR_TEAM_ID --password APP_SPECIFIC_PASSWORD"
echo "   4. Staple:   xcrun stapler staple ${DMG_PATH}"

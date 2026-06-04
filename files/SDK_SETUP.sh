#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#  Android SDK + NDK Setup (Ubuntu/Debian/WSL2)
#  Run ONCE before BUILD_LOCAL.sh
# ─────────────────────────────────────────────────────────────────
set -e

INSTALL_DIR="${HOME}/Android/Sdk"
CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"

echo "▶ Installing Android SDK to: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR/cmdline-tools"
cd /tmp

echo "▶ Downloading command-line tools…"
wget -q --show-progress "$CMDLINE_TOOLS_URL" -O cmdline-tools.zip
unzip -q cmdline-tools.zip -d /tmp/cmdline-extract

# SDK expects: cmdline-tools/latest/
mkdir -p "$INSTALL_DIR/cmdline-tools/latest"
mv /tmp/cmdline-extract/cmdline-tools/* "$INSTALL_DIR/cmdline-tools/latest/"
rm -rf /tmp/cmdline-extract /tmp/cmdline-tools.zip

SDKMANAGER="$INSTALL_DIR/cmdline-tools/latest/bin/sdkmanager"

echo "▶ Accepting licenses…"
yes | "$SDKMANAGER" --licenses >/dev/null 2>&1 || true

echo "▶ Installing Android SDK Platform 34 + Build Tools 34.0.0…"
"$SDKMANAGER" \
  "platforms;android-34" \
  "build-tools;34.0.0" \
  "platform-tools"

echo "▶ Installing NDK 27.3.13750724 (required, ~1.6 GB)…"
"$SDKMANAGER" "ndk;27.3.13750724"

echo ""
echo "══════════════════════════════════════════════════════"
echo "✓  Android SDK + NDK installed at: $INSTALL_DIR"
echo "══════════════════════════════════════════════════════"
echo ""
echo "Add to your ~/.bashrc or ~/.zshrc:"
echo "  export ANDROID_HOME=\"$INSTALL_DIR\""
echo "  export ANDROID_SDK_ROOT=\"$INSTALL_DIR\""
echo "  export PATH=\"\$PATH:\$ANDROID_HOME/platform-tools\""

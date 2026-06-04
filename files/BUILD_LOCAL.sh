#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#  DURBIN Launcher – Local Machine Build Script (Milestone 1)
#  Run on: Ubuntu 22.04+ / macOS / WSL2
# ─────────────────────────────────────────────────────────────────
set -e

echo "╔══════════════════════════════════════════════════════╗"
echo "║  DURBIN Launcher – Local Debug Build                 ║"
echo "╚══════════════════════════════════════════════════════╝"

# ── Paths (edit if needed) ────────────────────────────────────────
ANDROID_SDK_ROOT="${HOME}/Android/Sdk"
JAVA_HOME_PATH="/usr/lib/jvm/java-21-openjdk-amd64"   # Linux default
# macOS: JAVA_HOME_PATH="$(/usr/libexec/java_home -v 21)"

# ── Checks ───────────────────────────────────────────────────────
echo ""
echo "▶ Checking prerequisites…"

if ! java -version 2>&1 | grep -q "21"; then
  echo "✗  Java 21 not found. Install Temurin 21:"
  echo "   https://adoptium.net/temurin/releases/?version=21"
  exit 1
else
  echo "✓  Java 21 found: $(java -version 2>&1 | head -1)"
fi

if [ ! -d "$ANDROID_SDK_ROOT/platforms/android-34" ]; then
  echo ""
  echo "✗  Android SDK API 34 not found at: $ANDROID_SDK_ROOT"
  echo "   Run the setup section below, or open Android Studio → SDK Manager"
  echo "   and install: Android 14 (API 34), Build-Tools 34.0.0, NDK 27.3.13750724"
  exit 1
fi

if [ ! -d "$ANDROID_SDK_ROOT/ndk/27.3.13750724" ]; then
  echo ""
  echo "✗  NDK 27.3.13750724 not found."
  echo "   sdkmanager \"ndk;27.3.13750724\""
  exit 1
fi

echo "✓  Android SDK found: $ANDROID_SDK_ROOT"
echo "✓  NDK 27.3.13750724 found"

# ── Set up SDK env ────────────────────────────────────────────────
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export ANDROID_SDK_ROOT="$ANDROID_SDK_ROOT"
export JAVA_HOME="$JAVA_HOME_PATH"

# ── Language list ─────────────────────────────────────────────────
echo ""
echo "▶ Regenerating language list…"
./scripts/languagelist_updater.sh

# ── Build ─────────────────────────────────────────────────────────
echo ""
echo "▶ Building debug APK (this takes 5–15 min first run)…"
./gradlew :app_pojavlauncher:assembleDebug \
  --stacktrace \
  --warning-mode all

echo ""
echo "══════════════════════════════════════════════════════"
echo "✓  BUILD COMPLETE"
APK="app_pojavlauncher/build/outputs/apk/debug/app_pojavlauncher-debug.apk"
echo "   APK: $APK"
ls -lh "$APK"
echo "══════════════════════════════════════════════════════"
echo ""
echo "Install on device:"
echo "  adb install -r $APK"

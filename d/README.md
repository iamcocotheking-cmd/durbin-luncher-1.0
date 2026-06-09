# DURBIN Launcher

Patch overlay for [Amethyst-Android](https://github.com/AngelAuraMC/Amethyst-Android) (PojavLauncher fork). This repo is **not** a standalone Android project — it applies DURBIN UI theming and local account fixes on top of the real launcher backend.

## What this repo contains

- `app_pojavlauncher/` — overlay files merged into Amethyst at build time
- `scripts/` — setup, patch, and build helpers
- `assets/durbin_logo.png` — place your DURBIN spyglass logo here (optional; XML placeholder used until then)

## Prerequisites

- Git
- JDK 21
- Android SDK (via Android Studio or command-line tools)
- Python 3 (for offline-account profile patch)

## Build (Windows)

```powershell
cd "c:\Users\HP\OneDrive\Desktop\d"
.\scripts\setup.ps1
.\scripts\build.ps1
```

## Build (manual)

```bash
git clone --recursive --branch v3_openjdk https://github.com/AngelAuraMC/Amethyst-Android.git
# merge app_pojavlauncher/ into Amethyst-Android/app_pojavlauncher/
python3 scripts/patch_offline_profile.py Amethyst-Android
cd Amethyst-Android
./gradlew :app_pojavlauncher:assembleDebug
```

## APK output

`Amethyst-Android/app_pojavlauncher/build/outputs/apk/debug/app_pojavlauncher-debug.apk`

## Local account

- Auth screen: **Microsoft Account** or **Local Account**
- Default username: `DURBIN_Player`
- Rules: 3–16 chars, letters/numbers/underscore only
- Local accounts appear in the account spinner and can launch offline / on offline-mode servers
- Does **not** bypass Microsoft auth on premium online servers

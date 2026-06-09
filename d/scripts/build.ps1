# DURBIN Launcher - build debug APK
param(
    [string]$AmethystDir = "Amethyst-Android"
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

if (-not (Test-Path $AmethystDir)) {
    & "$Root\scripts\setup.ps1" -AmethystDir $AmethystDir
}

Set-Location (Join-Path $Root $AmethystDir)
if (-not (Test-Path ".\gradlew.bat")) {
    throw "gradlew.bat missing in $AmethystDir. Re-run scripts\setup.ps1"
}

.\gradlew.bat :app_pojavlauncher:assembleDebug --stacktrace

$apk = Get-ChildItem "app_pojavlauncher\build\outputs\apk\debug\*.apk" | Select-Object -First 1
if ($apk) {
    Write-Host ""
    Write-Host "APK built: $($apk.FullName)"
} else {
    Write-Warning "Build finished but no APK found under app_pojavlauncher\build\outputs\apk\debug\"
}

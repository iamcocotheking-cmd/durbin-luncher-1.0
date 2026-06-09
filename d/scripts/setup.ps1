# DURBIN Launcher - clone Amethyst backend and apply overlay patches
param(
    [string]$AmethystDir = "Amethyst-Android",
    [string]$Branch = "v3_openjdk"
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

Write-Host "DURBIN setup in $Root"

if (-not (Test-Path $AmethystDir)) {
    Write-Host "Cloning Amethyst-Android ($Branch)..."
    git clone --recursive --branch $Branch --depth 1 `
        https://github.com/AngelAuraMC/Amethyst-Android.git $AmethystDir
} else {
    Write-Host "Using existing $AmethystDir"
}

Write-Host "Applying app_pojavlauncher overlay..."
robocopy "$Root\app_pojavlauncher" "$Root\$AmethystDir\app_pojavlauncher" /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
if ($LASTEXITCODE -ge 8) { throw "robocopy failed with exit code $LASTEXITCODE" }

$logoCandidates = @(
    (Join-Path $Root "assets\durbin_logo.png"),
    "$env:USERPROFILE\.cursor\projects\c-Users-HP-OneDrive-Desktop-d\assets\c__Users_HP_AppData_Roaming_Cursor_User_workspaceStorage_d61086dd1438997f1386e19bcc2b3931_images_e14bdbe9421a34892a7b65d30d096f8a-1-9beb590b-70d9-4fc6-9421-e64038c97044.png"
)
$logoDst = Join-Path $Root "$AmethystDir\app_pojavlauncher\src\main\res\drawable\durbin_logo.png"
$logoXml = Join-Path $Root "$AmethystDir\app_pojavlauncher\src\main\res\drawable\durbin_logo.xml"
$logoSrc = $logoCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if ($logoSrc) {
    New-Item -ItemType Directory -Force -Path (Split-Path $logoDst) | Out-Null
    Copy-Item $logoSrc $logoDst -Force
    if (Test-Path $logoXml) { Remove-Item $logoXml -Force }
    New-Item -ItemType Directory -Force -Path (Join-Path $Root "assets") | Out-Null
    Copy-Item $logoSrc (Join-Path $Root "assets\durbin_logo.png") -Force
    Write-Host "Installed DURBIN logo from $logoSrc"
} else {
    Write-Warning "Logo PNG not found - using orange placeholder drawable until you add assets\durbin_logo.png"
}

Write-Host "Patching offline profile creation gate..."
python "$Root\scripts\patch_offline_profile.py" "$Root\$AmethystDir"

$stringsFile = Join-Path $Root "$AmethystDir\app_pojavlauncher\src\main\res\values\strings.xml"
if (Test-Path $stringsFile) {
    (Get-Content $stringsFile -Raw) -replace '(?s)<string name="app_name">.*?</string>',
        '<string name="app_name">DURBIN Launcher</string>' |
        Set-Content $stringsFile -Encoding UTF8
    Write-Host "Updated app display name to DURBIN Launcher"
}

$langScript = Join-Path $Root "$AmethystDir\scripts\languagelist_updater.sh"
if (Test-Path $langScript) {
    Write-Host "Regenerating language list (Git Bash recommended on Windows)..."
    bash $langScript
}

Write-Host ""
Write-Host "Setup complete. Build with:"
Write-Host "  cd $AmethystDir"
Write-Host "  .\gradlew.bat :app_pojavlauncher:assembleDebug"

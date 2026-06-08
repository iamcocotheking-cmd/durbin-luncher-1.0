# DURBIN Profile Creation Offline Fix

This patch updates GitHub Actions to patch the cloned Amethyst source before building.

Fix target:
- Tools.hasOnlineProfile() returns true so local launcher utility/profile creation menus do not block Offline Account users with Microsoft account dialogs.

This does not bypass Microsoft authentication for official online servers. The actual game launch still uses the selected account validation in LauncherActivity.

Test after installing the new APK:
- Create Vanilla Profile
- Create Fabric Profile
- Create Forge Profile
- Create Modpack Profile
with an Offline Account selected.

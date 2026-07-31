# YASB configuration

## DingTalk unread reminder

Prerequisites:

- DingTalk installed in its default location.
- AutoHotkey v2 installed in its default location.

After cloning the unified dotfiles repository, build and install the native toast sender, register its Windows notification identity and the `dingtalk-reminder:` URI protocol handler, and install the badge monitor startup shortcut:

```powershell
pwsh -NoProfile -File "$HOME\windows-dotfiles\yasb\install-dingtalk-reminder.ps1"
```

The installer builds `DingTalkToast.exe` with the C# compiler included in Windows. Generated executables and icons stay under `%LOCALAPPDATA%\YASB`; only their reproducible source and installer are stored in Git. The monitor removes its toast when the unread badge clears. Clicking the toast restores and focuses a running DingTalk window or starts DingTalk when needed.

## Winget update widget

The update widget is hidden when no upgrades are available. When visible, its label shows the upgrade count and its tooltip lists each application with the installed and available versions. Left-click upgrades all applications in a terminal; right-click refreshes the list immediately.

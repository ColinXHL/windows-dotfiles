# YASB configuration

## DingTalk unread reminder

Prerequisites:

- PowerShell 7 (`pwsh.exe`) for the documented installation command.
- DingTalk installed in its default location.
- AutoHotkey v2 installed in its default location.
- The 64-bit .NET Framework 4.x C# compiler/runtime and Windows Runtime metadata
  used by the installer, normally supplied as Windows components.

After cloning the unified dotfiles repository, build and install the native toast sender, register its Windows notification identity and the `dingtalk-reminder:` URI protocol handler, and install the badge monitor startup shortcut:

```powershell
pwsh -NoProfile -File "$HOME\windows-dotfiles\yasb\install-dingtalk-reminder.ps1"
```

The installer builds `DingTalkToast.exe` with the configured .NET Framework C#
compiler. Generated executables and icons stay under `%LOCALAPPDATA%\YASB`; only
their reproducible source and installer are stored in Git. The monitor removes
its toast when the unread badge clears. Clicking the toast attempts to restore
and focus a running DingTalk main window, or starts DingTalk from its configured
default path when no window is found.

## Winget update widget

The update widget requires PowerShell 7 (`pwsh.exe`) and Windows Package Manager
(`winget.exe`). It is hidden when no upgrades are available. When visible, its
label shows the upgrade count and its tooltip lists each application with the
installed and available versions. Left-click upgrades all eligible applications
in a terminal; right-click refreshes the list immediately.

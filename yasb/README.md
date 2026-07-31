# YASB configuration

## DingTalk unread reminder

Prerequisites:

- DingTalk installed in its default location.
- AutoHotkey v2 installed in its default location.

After cloning the unified dotfiles repository, build and install the native toast sender, register its Windows notification identity, and install the badge monitor startup shortcut:

```powershell
pwsh -NoProfile -File "$HOME\windows-dotfiles\yasb\install-dingtalk-reminder.ps1"
```

The installer builds `DingTalkToast.exe` with the C# compiler included in Windows. Generated executables and icons stay under `%LOCALAPPDATA%\YASB`; only their reproducible source and installer are stored in Git.

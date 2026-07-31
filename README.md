# Windows Dotfiles

Personal Windows configuration managed from one repository.

## Contents

| Directory | Configuration |
| --- | --- |
| `wezterm/` | WezTerm appearance, key bindings, and runtime behavior |
| `nushell/` | Nushell, Starship, and Fastfetch configuration |
| `nvim/` | Neovim and LazyVim configuration |
| `yazi/` | Yazi file manager configuration |
| `opencode/` | OpenCode application and TUI configuration |
| `glzr/` | GlazeWM and Zebar configuration |
| `yasb/` | YASB widgets, styling, and local helper sources |
| `nilesoft-shell/` | Nilesoft Shell context menu configuration |

The WezTerm, Nushell, and Nilesoft Shell histories were imported from their
original repositories with Git subtree. Application-specific documentation is
kept in each directory.

## Install

Clone the repository and run the installer from PowerShell 7:

```powershell
git clone https://github.com/ColinXHL/windows-dotfiles.git "$HOME\windows-dotfiles"
pwsh -NoProfile -File "$HOME\windows-dotfiles\install.ps1"
```

The installer creates these symbolic links:

```text
~/.config/wezterm/wezterm.lua     -> <repo>/wezterm/wezterm.lua
~/.config/wezterm/modules/*.lua   -> <repo>/wezterm/modules/*.lua
~/.config/nushell/config.nu       -> <repo>/nushell/config.nu
~/.config/nushell/modules/*.nu    -> <repo>/nushell/modules/*.nu
~/.config/nushell/fastfetch.jsonc -> <repo>/nushell/fastfetch.jsonc
~/.config/starship.toml           -> <repo>/nushell/starship.toml
%APPDATA%/nushell/config.nu       -> <repo>/nushell/config.nu
%LOCALAPPDATA%/nvim/*             -> <repo>/nvim/*
%APPDATA%/yazi/config/*.toml      -> <repo>/yazi/*.toml
~/.config/opencode/opencode.jsonc -> <repo>/opencode/opencode.jsonc
~/.config/opencode/tui.json       -> <repo>/opencode/tui.json
~/.glzr/glazewm/config.yaml       -> <repo>/glzr/glazewm/config.yaml
~/.glzr/zebar/settings.json       -> <repo>/glzr/zebar/settings.json
~/.config/yasb/*                  -> <repo>/yasb/*
```

Existing files are moved to timestamped backups before links are created.
Windows Developer Mode or an elevated terminal is required to create symbolic
links. File-level links allow the installer to run while WezTerm is open.

To build and register the optional DingTalk unread reminder after installing
DingTalk and AutoHotkey v2, run:

```powershell
pwsh -NoProfile -File "$HOME\windows-dotfiles\yasb\install-dingtalk-reminder.ps1"
```

Nilesoft Shell is installed by copying the tracked files into its directory in
`Program Files` and restarting the application. This step requires elevation.
Use `-SkipNilesoft` when only the user-level configurations should be linked.

## Local State

Generated files, caches, package dependencies, histories, credentials, and API
keys remain outside this repository. In particular, OpenCode's `node_modules`
and package metadata stay in `~/.config/opencode`; Yazi flavors and state stay
in `%APPDATA%/yazi`; and GlazeWM/Zebar logs, downloads, and caches stay in their
application directories. YASB logs, weather credentials, DingTalk reminder
state, and generated helper executables stay outside the repository.

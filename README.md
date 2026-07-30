# Windows Dotfiles

Personal Windows configuration managed from one repository.

## Contents

| Directory | Configuration |
| --- | --- |
| `wezterm/` | WezTerm appearance, key bindings, and runtime behavior |
| `nushell/` | Nushell, Starship, and Fastfetch configuration |
| `opencode/` | OpenCode application and TUI configuration |
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
~/.config/wezterm                 -> <repo>/wezterm
~/.config/nushell                 -> <repo>/nushell
~/.config/starship.toml           -> <repo>/nushell/starship.toml
%APPDATA%/nushell/config.nu       -> <repo>/nushell/config.nu
~/.config/opencode/opencode.jsonc -> <repo>/opencode/opencode.jsonc
~/.config/opencode/tui.json       -> <repo>/opencode/tui.json
```

Existing files and directories are moved to timestamped backups before links
are created. Windows Developer Mode or an elevated terminal is required to
create symbolic links.

Nilesoft Shell is installed by copying the tracked files into its directory in
`Program Files` and restarting the application. This step requires elevation.
Use `-SkipNilesoft` when only the user-level configurations should be linked.

## Local State

Generated files, caches, package dependencies, histories, credentials, and API
keys remain outside this repository. In particular, OpenCode's `node_modules`
and package metadata stay in `~/.config/opencode`.

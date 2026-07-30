# Nushell configuration

Windows-first configuration for Nushell running in WezTerm. Validated with Nushell 0.114.1 and Starship 1.26.0.

## Files

- `config.nu`: entrypoint and deterministic module load order
- `modules/core.nu`: editor, terminal integration, history, file and table behavior
- `modules/prompt.nu`: status-aware transient prompt
- `modules/completions.nu`: fuzzy IDE-style completion menu and Tab behavior
- `modules/proxy.nu`: default local proxy and `proxy-on`/`proxy-off`
- `modules/commands.nu`: aliases, Git abbreviations, `mkcd`, and Yazi wrapper
- `starship.toml`: official Tokyo Night preset
- `fastfetch.jsonc`: Windows desktop module selection without unsupported probes
- `install.ps1`: idempotent Windows symbolic-link installer

History databases, plugin registries, backups, and generated vendor scripts are intentionally excluded.

## Requirements

- Nushell 0.114.1 or newer compatible release
- WezTerm with Kitty keyboard protocol support
- Starship
- Fastfetch
- Neovim
- Git
- Yazi
- Zoxide
- fzf, required by `zi`
- A Nerd Font for prompt symbols

## Generated integrations

Generate Starship's Nushell autoload file:

```nu
mkdir ($nu.data-dir | path join "vendor" "autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor" "autoload" "starship.nu")
```

Generate Zoxide's Nushell source file:

```nu
zoxide init nushell | save -f ~/.zoxide.nu
```

These files are generated for the local installation and should not be committed.

## Windows links

The repository is the source of truth. The active files are symbolic links:

```text
%APPDATA%\nushell\config.nu -> ~/.config/nushell/config.nu
~/.config/starship.toml      -> ~/.config/nushell/starship.toml
```

Creating symbolic links requires Windows Developer Mode or an elevated terminal.

Clone the repository to `~/.config/nushell`, then run:

```powershell
pwsh -NoProfile -File "$HOME\.config\nushell\install.ps1"
```

The installer leaves correct existing links unchanged. Existing regular files are moved to timestamped `.bak` files before links are created.

## Behavior

- Fastfetch runs only in a top-level shell (`SHLVL == 1`) and skips unsupported desktop probes.
- Starship keeps the active prompt complete, shows commands taking at least two seconds, and collapses completed prompts to a status-colored arrow.
- Tab opens the IDE completion menu; arrows select; a second Tab accepts without executing.
- `rm` uses the Recycle Bin by default. Use `rm --permanent` for permanent deletion.
- `proxy-on` uses `http://127.0.0.1:7890`; `proxy-off` restores the inherited proxy variables.
- `ff` runs Fastfetch.
- `gs`, `ga`, `gc`, `gp`, and `gl` expand to editable full Git commands.
- `y` starts Yazi and returns to its final directory.
- `z` and `zi` are provided by Zoxide.

## Multiline paste on Windows

Nushell 0.114.1 disables Reedline bracketed paste on Windows because Crossterm does not yet produce paste events there. Multiline terminal paste may therefore execute one complete line at a time.

Use `Ctrl+O` at the Nushell prompt to open the command buffer in Neovim. Paste and edit there, save with `:wq`, review the returned command buffer, and press Enter explicitly.

Upstream references:

- https://github.com/crossterm-rs/crossterm/issues/737
- https://github.com/crossterm-rs/crossterm/pull/1030

## Validation

```nu
nu --ide-check 100 ~/.config/nushell/config.nu
starship timings
```

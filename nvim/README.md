# Neovim Development Environment

This is a project-oriented LazyVim configuration for C++ development over SSH.
It uses Catppuccin Mocha with a transparent editor background, terminal-native
Markdown rendering, clangd, CMake language support, and a deliberately small
set of primary keys.

## Project Workflow

Start Neovim from a project root:

```bash
nvim .
```

clangd works best when the project exports `compile_commands.json`:

```bash
cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build
```

Keep build, compiler, clangd, and Neovim in the same Linux environment. The
documented primary build and debug workflow uses the terminal.

## Primary Keys

`<leader>` is `Space`. Pause after pressing it to open which-key.

| Area | Key | Action |
| --- | --- | --- |
| Project | `<leader><space>` | Find project files |
| Project | `<leader>/` | Search text across the project |
| Project | `<leader>e` | Toggle the project explorer |
| Project | `<leader>,` | Pick an open buffer |
| Buffer | `[b` / `]b` | Previous / next buffer |
| Buffer | `<leader>bd` | Close the current buffer |
| Session | `<leader>qs` | Restore the current project session |
| Save | `Ctrl+S` | Save the current file |
| Terminal | `<leader>t` | Toggle a terminal at the project root |
| Window | `Ctrl+H/J/K/L` | Move between Neovim windows |
| Window | `<leader>|` / `<leader>-` | Split right / below |
| Code | `gd` | Go to definition |
| Code | `gr` | List references |
| Code | `K` | Show hover documentation |
| Code | `<leader>ca` | Code action |
| Code | `<leader>cr` | Rename symbol |
| Code | `<leader>cf` | Format file or selection |
| C/C++ | `<leader>ch` | Switch source/header |
| Diagnostics | `[d` / `]d` | Previous / next diagnostic |
| Diagnostics | `<leader>xx` | Project diagnostics |
| Git | `[h` / `]h` | Previous / next changed hunk |
| Git | `<leader>ghp` | Preview the current hunk |
| Git | `<leader>gg` | Lazygit, when installed |
| Markdown | `<leader>um` | Toggle terminal rendering |
| LSP | `<leader>uh` | Toggle inlay hints |
| Comment | `Ctrl+/` | Toggle comment for the current line or selection |

Vim's native `s`, `S`, `H`, and `L` behavior is preserved. Flash navigation,
browser Markdown preview, OpenCode integration, and DAP are intentionally
disabled or omitted. CMake language support and cmake-tools commands remain
available, but no CMake command has a primary key binding.

The Linux package option installs: a C/C++ compiler, clangd/clang tools, CMake,
Ninja, Git, tmux, ripgrep, fd, Node/npm, Python/pip, curl, tar, and unzip. Node
and Python are needed by the JSON, YAML, and CMake tooling installed through
Mason. Markdown lint/TOC tools are omitted to avoid requiring Node 22 on every
remote distribution.

## Completion

Completion uses Blink's `enter` preset. `Enter` accepts the selected item,
`Ctrl+N/P` moves through suggestions, `Ctrl+Space` opens completion, and `Tab`
moves through snippets when a snippet is active.

## SSH Clipboard

Do not set `clipboard=unnamedplus`: normal deletes and yanks should not rewrite
the Windows clipboard. Use `"+y` explicitly, and verify the remote path with:

```vim
:checkhealth vim.provider
```

Inside tmux, also verify:

```bash
tmux show -s set-clipboard
tmux info | grep 'Ms:'
```

The expected values are `on` and a non-missing `Ms` capability.

# WezTerm Config

一套面向 Windows 的模块化 WezTerm 配置，使用 Nushell、Retro Tab Bar 和 Vim/tmux 风格快捷键。

当前配置在 WezTerm Nightly `20260716-195552-76b606ec` 上验证通过。

## 特性

- Nushell 作为默认 Shell
- Tokyo Night Moon 配色与 Acrylic 背景
- 0xProto Nerd Font Mono 与中英文、Emoji Fallback
- `Ctrl+A` Leader 和模式化 Pane 操作
- Vim 风格 Copy/Search Mode
- Quick Select、鼠标选择和右键智能复制/粘贴
- 可搜索的自定义快捷键浮层
- 按职责拆分的 Lua 模块

## 依赖

- Windows 10 或 Windows 11
- [WezTerm](https://wezterm.org/installation.html)
- [Nushell](https://www.nushell.sh/)
- [0xProto Nerd Font Mono](https://www.nerdfonts.com/font-downloads)
- PowerShell 7，可选，用于 Launcher 菜单

`Microsoft YaHei UI` 和 `Segoe UI Emoji` 通常随 Windows 提供。首次加载时，WezTerm 会自动下载并缓存 [wezterm-cmdpicker](https://github.com/abidibo/wezterm-cmdpicker) 插件。

## 安装

WezTerm 会在 Windows 上自动读取 `%USERPROFILE%\.config\wezterm\wezterm.lua`。

```powershell
git clone https://github.com/ColinXHL/wezterm-config.git "$HOME/.config/wezterm"
```

如果目标目录已有配置，请先备份或迁移原有文件。配置及通过 `require` 加载的模块会被 WezTerm 自动监视，修改后通常会立即重载。

## 目录结构

```text
~/.config/wezterm/
|-- wezterm.lua
|-- README.md
`-- modules/
    |-- launch.lua
    |-- appearance.lua
    |-- mouse.lua
    |-- bindings.lua
    `-- status.lua
```

| 文件 | 职责 |
| --- | --- |
| `wezterm.lua` | 创建 Config，并显式控制模块加载顺序 |
| `modules/launch.lua` | 默认 Shell、工作目录和 Launcher 菜单 |
| `modules/appearance.lua` | 字体、配色、窗口、标签栏和 Pane 外观 |
| `modules/mouse.lua` | 鼠标选择、复制、粘贴和链接操作 |
| `modules/bindings.lua` | Leader、快捷键、Key Table 和 cmdpicker 插件 |
| `modules/status.lua` | Leader 与 Key Table 的右侧状态提示 |

每个模块都遵循 WezTerm 推荐的 `module.apply_to_config(config)` 约定。入口文件显式加载模块，不会自动执行目录中的其他 Lua 文件。

## 快捷键

Leader 为 `Ctrl+A`，超时为 1500ms。

| 快捷键 | 操作 |
| --- | --- |
| `Leader+a` | 向终端发送原始 `Ctrl+A` |
| `Leader+?` | 打开可搜索快捷键浮层 |
| `Leader+\|` | 左右分屏 |
| `Leader+-` | 上下分屏 |
| `Leader+d` | 关闭当前 Pane |
| `Alt+h/j/k/l` | 切换 Pane 焦点 |
| `Leader+r` | 进入 Pane 尺寸调整模式 |
| `Leader+z` | 切换 Pane Zoom |
| `Leader+s` | Quick Select 并复制 |
| `Leader+[` | 进入 Vim Copy Mode |
| `Alt+1..9` | 切换到对应 Tab |
| `Ctrl+Shift+T` | 新建 Tab |
| `Ctrl+Shift+F` | 搜索终端历史 |
| `Ctrl+Shift+P` | 打开命令面板 |
| `Ctrl+Shift+R` | 重新加载配置 |
| `Alt+Enter` | 切换全屏 |

Pane 尺寸调整模式使用 `h/j/k/l` 调整，使用 `Esc` 或 `q` 退出。

Copy Mode 使用 `/` 搜索、`n/p` 切换匹配、`v` 选择、`y` 复制并退出，使用 `Esc` 或 `q` 清理状态并退出。

## 鼠标

| 操作 | 行为 |
| --- | --- |
| 左键拖动 | 选择文本并保留选区 |
| 双击 | 选择单词 |
| 三击 | 选择整行 |
| `Alt+左键拖动` | 块选择 |
| 右键，有选区 | 复制并清除选区 |
| 右键，无选区 | 粘贴系统剪贴板 |
| `Ctrl+左键单击` | 打开鼠标下的链接 |

## 验证

检查配置和最终快捷键表：

```powershell
wezterm show-keys
```

检查字体解析：

```powershell
wezterm ls-fonts
```

检查外部程序：

```powershell
wezterm -V
nu --version
pwsh --version
```

## 自定义

- 修改默认 Shell 或 Launcher：`modules/launch.lua`
- 修改字体、主题或透明度：`modules/appearance.lua`
- 修改鼠标行为：`modules/mouse.lua`
- 修改快捷键和模式：`modules/bindings.lua`
- 修改模式状态提示：`modules/status.lua`

这份配置包含 Windows 专属的 Acrylic 和集成窗口按钮设置；在其他平台使用时需要调整 `modules/appearance.lua`。

local wezterm = require("wezterm")

local M = {}

function M.apply_to_config(config)
	local nf = wezterm.nerdfonts

	config.font = wezterm.font_with_fallback({
		"0xProto Nerd Font Mono",
		"Microsoft YaHei UI",
		"Segoe UI Emoji",
	})
	-- 96 DPI 下 12pt 正好是 16px，避免图标落在非整数像素上发糊。
	config.font_size = 12

	-- 匹配当前 75Hz 显示器。
	config.max_fps = 75
	config.animation_fps = 75

	-- 不喜欢连字时取消下面代码的注释。
	-- config.harfbuzz_features = {
	--   "calt=0",
	--   "clig=0",
	--   "liga=0",
	-- }

	config.color_scheme = "Tokyo Night Moon"
	config.window_background_opacity = 0.35
	config.win32_system_backdrop = "Acrylic"
	-- Keep the rainy Tokyo artwork moving subtly with terminal scrollback.
	config.background = {
		{
			source = { File = wezterm.config_dir .. "/assets/tokyo-night-parallax.png" },
			attachment = { Parallax = 0.15 },
			repeat_x = "NoRepeat",
			repeat_y = "NoRepeat",
			horizontal_align = "Center",
			vertical_align = "Top",
			width = "Cover",
			height = "Cover",
			opacity = 0.55,
			hsb = {
				saturation = 0.95,
				brightness = 0.75,
			},
		},
		{
			source = { Color = "#070b18" },
			width = "100%",
			height = "100%",
			opacity = 0.08,
		},
	}

	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
	config.window_padding = {
		left = 10,
		right = 10,
		top = 8,
		bottom = 8,
	}

	config.initial_cols = 140
	config.initial_rows = 40
	config.adjust_window_size_when_changing_font_size = false
	config.scrollback_lines = 20000
	config.audible_bell = "Disabled"
	config.default_cursor_style = "BlinkingBar"

	config.use_fancy_tab_bar = false
	config.show_new_tab_button_in_tab_bar = false
	config.tab_max_width = 28
	config.switch_to_last_active_tab_when_closing_tab = true
	config.tab_bar_style = {
		window_hide = " " .. nf.cod_chrome_minimize .. " ",
		window_hide_hover = " " .. nf.cod_chrome_minimize .. " ",
		window_maximize = " " .. nf.cod_chrome_maximize .. " ",
		window_maximize_hover = " " .. nf.cod_chrome_maximize .. " ",
		window_close = " " .. nf.cod_chrome_close .. " ",
		window_close_hover = " " .. nf.cod_chrome_close .. " ",
	}

	config.inactive_pane_hsb = {
		saturation = 0.85,
		brightness = 0.72,
	}
end

return M

local wezterm = require("wezterm")
local act = wezterm.action

local M = {}
local mouse_dragging = {}

function M.apply_to_config(config)
	config.mouse_bindings = {
		-- 普通单击只定位；发生拖动时保留选区，等待右键复制。
		{
			event = { Down = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = wezterm.action_callback(function(window, pane)
				mouse_dragging[pane:pane_id()] = false
				window:perform_action(act.SelectTextAtMouseCursor("Cell"), pane)
			end),
		},
		{
			event = { Drag = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = wezterm.action_callback(function(window, pane)
				mouse_dragging[pane:pane_id()] = true
				window:perform_action(act.ExtendSelectionToMouseCursor("Cell"), pane)
			end),
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = wezterm.action_callback(function(window, pane)
				local pane_id = pane:pane_id()
				if not mouse_dragging[pane_id] then
					window:perform_action(act.ClearSelection, pane)
				end
				mouse_dragging[pane_id] = nil
			end),
		},

		-- 双击、三击和块选择完成后保留选区。
		{
			event = { Up = { streak = 2, button = "Left" } },
			mods = "NONE",
			action = act.Nop,
		},
		{
			event = { Up = { streak = 3, button = "Left" } },
			mods = "NONE",
			action = act.Nop,
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "SHIFT",
			action = act.Nop,
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "ALT",
			action = act.Nop,
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "ALT|SHIFT",
			action = act.Nop,
		},

		-- Ctrl+单击打开链接；吞掉 Down 事件，避免 TUI 只收到半次点击。
		{
			event = { Down = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.Nop,
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.OpenLinkAtMouseCursor,
		},

		-- 右键：有选区时复制并清除，否则粘贴系统剪贴板。
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = wezterm.action_callback(function(window, pane)
				if window:get_selection_text_for_pane(pane) ~= "" then
					window:perform_action(act.CopyTo("Clipboard"), pane)
					window:perform_action(act.ClearSelection, pane)
				else
					window:perform_action(act.PasteFrom("Clipboard"), pane)
				end
			end),
		},
		{
			event = { Up = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = act.Nop,
		},
	}
end

return M

local wezterm = require("wezterm")
local act = wezterm.action

local M = {}
local mouse_dragging = {}

function M.apply_to_config(config)
	local left_down = wezterm.action_callback(function(window, pane)
		mouse_dragging[pane:pane_id()] = false
		window:perform_action(act.SelectTextAtMouseCursor("Cell"), pane)
	end)
	local left_drag = wezterm.action_callback(function(window, pane)
		mouse_dragging[pane:pane_id()] = true
		window:perform_action(act.ExtendSelectionToMouseCursor("Cell"), pane)
	end)
	local left_up = wezterm.action_callback(function(window, pane)
		local pane_id = pane:pane_id()
		if not mouse_dragging[pane_id] then
			window:perform_action(act.ClearSelection, pane)
		end
		mouse_dragging[pane_id] = nil
	end)
	config.mouse_bindings = {
		-- 普通单击只定位；发生拖动时保留选区，等待键盘复制。
		{
			event = { Down = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = left_down,
		},
		{
			event = { Drag = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = left_drag,
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = left_up,
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
	}
end

return M

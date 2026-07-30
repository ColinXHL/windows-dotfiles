local wezterm = require("wezterm")

local M = {}

local full_bleed_processes = {
	["nvim"] = true,
	["nvim.exe"] = true,
	["opencode"] = true,
	["opencode.exe"] = true,
}

local opaque_processes = {
	["nvim"] = true,
	["nvim.exe"] = true,
	["opencode"] = true,
	["opencode.exe"] = true,
}

local process_backgrounds = {
	["opencode"] = "#0a0a0a",
	["opencode.exe"] = "#0a0a0a",
}

local active_apps = {}
local missed_app_checks = {}

local function update_window_padding(window, pane)
	local process_path = pane:get_foreground_process_name() or ""
	local process_name = (process_path:match("([^/\\]+)$") or ""):lower()
	local pane_title = (pane:get_title() or ""):lower()
	if pane_title:find("opencode", 1, true) then
		process_name = "opencode"
	elseif pane_title:find("nvim", 1, true) then
		process_name = "nvim"
	end

	local pane_id = pane:pane_id()
	if full_bleed_processes[process_name] then
		active_apps[pane_id] = process_name
		missed_app_checks[pane_id] = 0
	elseif active_apps[pane_id] and (missed_app_checks[pane_id] or 0) < 3 then
		missed_app_checks[pane_id] = (missed_app_checks[pane_id] or 0) + 1
		process_name = active_apps[pane_id]
	else
		active_apps[pane_id] = nil
		missed_app_checks[pane_id] = nil
	end

	local needs_full_bleed = full_bleed_processes[process_name] == true
	local needs_opaque_background = opaque_processes[process_name] == true
	local overrides = window:get_config_overrides() or {}
	local padding = overrides.window_padding
	local has_zero_padding = padding
		and padding.left == 0
		and padding.right == 0
		and padding.top == 0
		and padding.bottom == 0
	local has_expected_padding = needs_full_bleed == (has_zero_padding == true)
	local expected_opacity = needs_opaque_background and 1 or nil
	local expected_background = process_backgrounds[process_name]
	local overridden_background = overrides.colors and overrides.colors.background or nil
	local has_background_layer = overrides.background ~= nil
	local expects_background_layer = expected_background ~= nil

	if
		has_expected_padding
		and overrides.window_background_opacity == expected_opacity
		and overridden_background == expected_background
		and has_background_layer == expects_background_layer
	then
		return
	end

	overrides.window_padding = needs_full_bleed and {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	} or nil
	overrides.window_background_opacity = expected_opacity
	overrides.colors = expected_background and { background = expected_background } or nil
	overrides.background = expected_background and {
		{
			source = { Color = expected_background },
			width = "100%",
			height = "100%",
			opacity = 1,
		},
	} or nil
	window:set_config_overrides(overrides)
end

function M.apply_to_config(_)
	wezterm.on("update-status", function(window, pane)
		update_window_padding(window, pane)

		if window:leader_is_active() then
			window:set_right_status(" LEADER  ? commands ")
			return
		end

		local key_table = window:active_key_table()
		if key_table == "resize_pane" then
			window:set_right_status(" RESIZE  hjkl adjust  Esc/q exit ")
			return
		end
		if key_table == "copy_mode" then
			window:set_right_status(" COPY  / search  n/p matches  v select  y copy  Esc/q exit ")
			return
		end
		if key_table == "search_mode" then
			window:set_right_status(" SEARCH  type query  Enter accept  Esc cancel ")
			return
		end
		window:set_right_status(key_table and (" " .. key_table .. " ") or "")
	end)
end

return M

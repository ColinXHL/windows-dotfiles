local wezterm = require("wezterm")

local M = {}

function M.apply_to_config(_)
	wezterm.on("update-status", function(window)
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

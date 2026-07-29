local wezterm = require("wezterm")

local M = {}

function M.apply_to_config(config)
	-- WezTerm 启动时直接运行 Nushell，并从用户主目录启动。
	config.default_prog = { "nu.exe" }
	config.default_cwd = wezterm.home_dir

	config.launch_menu = {
		{
			label = "Nushell",
			args = { "nu.exe" },
		},
		{
			label = "Windows PowerShell",
			args = { "powershell.exe", "-NoLogo" },
		},
		{
			label = "Command Prompt",
			args = { "cmd.exe" },
		},
		{
			label = "PowerShell 7",
			args = { "pwsh.exe", "-NoLogo" },
		},
	}
end

return M

local wezterm = require("wezterm")

local config = wezterm.config_builder()

local modules = {
	"modules.launch",
	"modules.appearance",
	"modules.mouse",
	"modules.bindings",
	"modules.status",
}

for _, module in ipairs(modules) do
	require(module).apply_to_config(config)
end

return config

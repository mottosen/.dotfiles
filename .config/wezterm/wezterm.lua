local wezterm = require("wezterm")
local commands = require("commands")
local colors = require("colors")

local config = wezterm.config_builder()

-- Window
config.max_fps = 120
config.enable_wayland = true
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "NONE"
config.macos_window_background_blur = 20 -- not sure if this is only for mac?
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Text
config.font_size = 10
config.line_height = 1.2

-- Colors
config.colors = colors

-- Custom Commands
wezterm.on("augment-command-palette", function()
	return commands
end)

config.color_scheme = "AdventureTime"

return config

---@type wezterm
-- Pull in the wezterm API
local wezterm = require('wezterm')
local os = require 'os'
local utils = require("utils")

-- This will hold the configuration.
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
	config:set_strict_mode(true)
end

require("keys").apply(config)

config.default_prog = { "wsl" }
config.front_end =  "WebGpu"
config.window_padding = { left = 0.5, right = 0.5, top = 0.5, bottom = 0.5 }
config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.default_cursor_style = "BlinkingBar"
-- Updating the font:
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 12
config.line_height = 1.0

-- This is where you actually apply your config choices
-- Change colour scheme with daylight:
function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return 'Dark'
end

function scheme_for_appearance(appearance)
	if appearance:find 'Dark' then
		return 'Catppuccin Mocha'
	else
		return 'Catppuccin Latte'
	end
end

config.set_environment_variables = {
	OS_THEME = get_appearance()
}
config.color_scheme = scheme_for_appearance(get_appearance())


wezterm.plugin
	.require("C:/Applications/WezTerm/plugins/wezterm-bar")
	.apply_to_config(config)
wezterm.plugin
	.require('C:/Applications/WezTerm/plugins/smart-splits.nvim')
	.apply_to_config(config)
-- and finally, return the configuration to wezterm
return config

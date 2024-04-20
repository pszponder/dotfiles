-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-------------------------------------------------
--                START CONFIG                 --
-------------------------------------------------

config.color_scheme = 'Catppuccin Mocha'

config.font = wezterm.font_with_fallback {
	'LigaComicCodeNerdFont',
	'CaskaydiaCoveNerdFont',
	'Fira Code',
}

-- config.enable_scroll_bar = true
config.window_padding = {
	left = '1cell',
	right = '1cell',
	top = '0.05cell',
	bottom = '0.05cell',
}

-- config.window_background_opacity = 0.99

-------------------------------------------------
--                 END CONFIG                  --
-------------------------------------------------

-- and finally, return the configuration to wezterm
return config
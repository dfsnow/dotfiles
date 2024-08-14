local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font stuff
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 20.0
config.line_height = 1.02

-- Colors and theme
config.color_scheme = "Catppuccin Mocha"
config.enable_scroll_bar = true
config.window_padding = {
  left = "0.4cell",
  right = "1cell",
  top = "0",
  bottom = "0"
}
config.window_frame = {
  font = wezterm.font({ family = "Roboto", weight = "Bold" }),
  font_size = 14.0
}

-- Scrollback
config.scrollback_lines = 50000


return config

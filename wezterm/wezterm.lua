-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.adjust_window_size_when_changing_font_size = false

config.color_scheme = "Tomorrow Night"

config.enable_scroll_bar = true

config.font = wezterm.font_with_fallback({
  "FuraMono Nerd Font",
  "FuraMono Nerd Font Mono",
  "Noto Color Emoji",
})
config.font_size = 9.0

config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.hide_tab_bar_if_only_one_tab = true

config.scrollback_lines = 9999

config.window_decorations = "RESIZE"

config.keys = {
  { -- like konsole
    key = "(",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  { -- like konsole
    key = ")",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  { -- like konsole
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
}

-- and finally, return the configuration to wezterm
return config

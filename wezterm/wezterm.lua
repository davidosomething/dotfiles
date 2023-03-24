-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.adjust_window_size_when_changing_font_size = false

config.color_scheme = "Twilight (base16)"

config.enable_scroll_bar = true

-- test: ᴀʙᴄᴅᴇꜰɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ
-- cjk: (ﾉಥ益ಥ）ﾉ︵┻━┻
config.font = wezterm.font_with_fallback({
  -- "FuraMono Nerd Font", -- folder icon is double size, use mono version
  -- instead. See https://github.com/polybar/polybar/issues/991#issue-293786329
  "FuraMono Nerd Font Mono",
  "Noto Sans Mono", -- linux + smallcaps
  "Roboto Mono",
  "DejaVu Sans Mono",
  "SF Mono",
  "Consolas",
  "Monaco", -- mac + smallcaps
  "Noto Color Emoji",
  "Unifont", -- bitmap fallback with a lot of unicode
})

config.font_size = wezterm.hostname() == "Dotrakoun-Macbook-Pro" and 18.0
  or 12.0

config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.hide_tab_bar_if_only_one_tab = true

config.inactive_pane_hsb = {
  brightness = 0.5,
  saturation = 0.5,
}

config.scrollback_lines = 9999

config.window_decorations = "RESIZE"
config.window_padding = {
  left = "1.5cell",
  right = "1.5cell",
  top = "0.5cell",
  bottom = "0.5cell",
}

-- ===========================================================================

local k = setmetatable({}, { __index = table })

-- Disable some default keys
-- Use cli:
-- wezterm show-keys --lua
-- to see current mappings
local defaults_to_disable = {
  { key = "Enter", mods = "ALT" }, -- ToggleFullScreen bleh native fullscreen
  { key = "Tab", mods = "CTRL" }, -- ActivateTabRelative
  { key = "Tab", mods = "SHIFT|CTRL" }, -- ActivateTabRelative
  { key = '"', mods = "ALT|CTRL" }, -- SplitVertical
  { key = '"', mods = "CTRL|SHIFT|ALT" }, -- SplitVertical
  { key = "'", mods = "CTRL|SHIFT|ALT" }, -- SplitVertical
  { key = "%", mods = "ALT|CTRL" }, -- SplitHorizontal
  { key = "%", mods = "CTRL|SHIFT|ALT" }, -- SplitHorizontal
  { key = "5", mods = "CTRL|SHIFT|ALT" }, -- SplitHorizontal
  { key = "K", mods = "CTRL" }, -- ClearScrollback
  { key = "L", mods = "CTRL" }, -- ShowDebugOverlay
  { key = "M", mods = "CTRL" }, -- Hide
  { key = "M", mods = "SHIFT|CTRL" }, -- Hide
  { key = "N", mods = "CTRL" }, -- SpawnWindow
  { key = "R", mods = "CTRL" }, -- ReloadConfiguration
  { key = "R", mods = "SHIFT|CTRL" }, -- ReloadConfiguration
  { key = "T", mods = "CTRL" }, -- SpawnTab
  { key = "U", mods = "CTRL" }, -- CharSelect
  { key = "X", mods = "CTRL" }, -- ActivateCopyMode
  { key = "^", mods = "CTRL" }, -- ActivateTab
  { key = "Z", mods = "CTRL" }, -- TogglePaneZoomState
}
for _, cfg in pairs(defaults_to_disable) do
  cfg.action = act.DisableDefaultAssignment
  k:insert(cfg)
end

-- Add my keys, modeled after konsole
k:insert({
  key = "(",
  mods = "CTRL|SHIFT",
  action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
})
k:insert({
  key = ")",
  mods = "CTRL|SHIFT",
  action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
})
k:insert({
  key = "w",
  mods = "CMD",
  action = act.CloseCurrentPane({ confirm = true }),
})

config.keys = k

return config

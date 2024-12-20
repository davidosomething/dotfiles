local wezterm = require("wezterm")
local panes = require("dko/panes")
local theme = require("dko/theme")

--- Key bindings

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
  cfg.action = wezterm.action.DisableDefaultAssignment
  k:insert(cfg)
end

-- Add my keys, modeled after konsole
k:insert({
  key = "w",
  mods = "CMD",
  action = wezterm.action.CloseCurrentPane({ confirm = true }),
})
k:insert({
  key = "t",
  mods = "CTRL|SHIFT",
  action = wezterm.action_callback(theme.toggle),
})
-- Pick pane, swap with active
k:insert({
  key = "8",
  mods = "CTRL|SHIFT",
  action = wezterm.action.PaneSelect({ mode = "SwapWithActive" }),
})

-- Yes both number and ( ) bindings are needed, one for wezterm-git on arch
-- and one on wezterm stable from brew on mac
k:insert({
  key = "9",
  mods = "CTRL|SHIFT",
  action = wezterm.action_callback(panes.split_horz),
})
k:insert({
  key = "0",
  mods = "CTRL|SHIFT",
  action = wezterm.action_callback(panes.split_vert),
})
k:insert({
  key = "(",
  mods = "CTRL|SHIFT",
  action = wezterm.action_callback(panes.split_horz),
})
k:insert({
  key = ")",
  mods = "CTRL|SHIFT",
  action = wezterm.action_callback(panes.split_vert),
})

return k

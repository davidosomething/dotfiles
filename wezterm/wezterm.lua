-- Pull in the wezterm API
local wezterm = require("wezterm")

local act = wezterm.action

local hidpi = wezterm.hostname() == "Dotrakoun-Macbook-Pro"

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.audible_bell = "Disabled"

config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "EaseIn"
config.cursor_blink_rate = 400

config.default_cursor_style = hidpi and "SteadyBlock" or "BlinkingBlock"

config.enable_scroll_bar = true

config.enable_wayland = false

config.hide_tab_bar_if_only_one_tab = true

config.inactive_pane_hsb = {
  brightness = 0.5,
  saturation = 0.5,
}

config.scrollback_lines = 9999

config.swallow_mouse_click_on_pane_focus = true
config.swallow_mouse_click_on_window_focus = true

config.window_padding = {
  left = "1.5cell",
  right = "1.5cell",
  top = "0.5cell",
  bottom = "0.5cell",
}

-- ===========================================================================
-- Fonts
-- ===========================================================================

-- Fix double-wide nerd fonts when using builtin Nerd Font Symbols
config.allow_square_glyphs_to_overflow_width = "Never"

config.adjust_window_size_when_changing_font_size = false

config.command_palette_font_size = hidpi and 24.0 or 16.0

config.font = wezterm.font_with_fallback({
  -- wez recommends against using patched nerd fonts because of mangled
  -- metadata so don't use these:
  --  - "FuraMono Nerd Font" disabled
  --      - folder icon is double size, use mono version instead.
  --        See https://github.com/polybar/polybar/issues/991#issue-293786329
  --  - "FuraMono Nerd Font Mono" disabled

  --  - "Fira Mono" disabled
  -- Prefer stylistic updates from Fira Code but with ligatures disabled
  -- a g i l r 3 ~ $ % * () {} |
  {
    family = "Fira Code",
    harfbuzz_features = {
      "calt=0", -- no ligatures => ===
      "clig=0", -- no contextual ligatures ft
      "ss03", -- & clarified
      "ss05", -- @ rounded
      "ss06", -- \\ \n dimmed char escapes
      "zero", -- dotted 0
    },
  },

  -- charset fallbacks ᴀʙᴄᴅᴇꜰɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ (ﾉಥ益ಥ）ﾉ︵┻━┻
  "Noto Sans Mono", -- linux + smallcaps
  "Monaco", -- mac + smallcaps
  { family = "Unifont", scale = 1.2 }, -- bitmap fallback with a lot of unicode

  -- emoji fallback 👉 👀 😁 💩 ✅
  "Noto Color Emoji",
})

config.font_dirs = { "fonts" }

config.font_size = hidpi and 18.0 or 12.0

config.line_height = 1.2

-- ===========================================================================
-- Theme
-- ===========================================================================

local xdg_state_home = os.getenv("XDG_STATE_HOME")
  or os.getenv("HOME") .. "/.local/state"
local colorscheme_file = ("%s/wezterm-colorscheme.txt"):format(xdg_state_home)

local notifier = "osascript -e 'display notification"
local close = "'"
if wezterm.target_triple == "x86_64-unknown-linux-gnu - Linux" then
  notifier = "notify-send"
  close = ""
end

---@param next_mode string
local sync_colorscheme = function(next_mode)
  local handler = io.open(colorscheme_file, "w")
  if handler then
    os.execute(
      ('%s "updated %s with %s"%s'):format(
        notifier,
        colorscheme_file,
        next_mode,
        close
      )
    )
    handler:write(next_mode)
    handler:close()
  else
    os.execute(
      ('%s "could not update %s with %s"%s'):format(
        notifier,
        colorscheme_file,
        next_mode,
        close
      )
    )
  end
end

local colorschemes = {
  dark = "Twilight (base16)",
  light = "Solarized (light) (terminal.sexy)",
}

local handler = io.open(colorscheme_file, "r")
if handler then
  local key = handler:read()
  config.color_scheme = colorschemes[key]
  handler:close()
else
  config.color_scheme = colorschemes.dark
end

local toggle_colorscheme = function(win)
  local ecfg = win:effective_config()
  local next_mode = ecfg.color_scheme == colorschemes.light and "dark"
    or "light"
  local overrides = win:get_config_overrides() or {}
  local next_colorscheme = colorschemes[next_mode]
  overrides.color_scheme = next_colorscheme
  win:set_config_overrides(overrides)
  sync_colorscheme(next_mode)
end

-- ===========================================================================
-- Key bindings
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

k:insert({
  key = "T",
  mods = "CTRL|SHIFT",
  action = wezterm.action_callback(toggle_colorscheme),
})

-- Pick pane, swap with active
k:insert({
  key = "8",
  mods = "CTRL|SHIFT",
  action = act.PaneSelect({ mode = "SwapWithActive" }),
})

config.keys = k

return config

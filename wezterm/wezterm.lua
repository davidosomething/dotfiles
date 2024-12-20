local wezterm = require("wezterm")
local panes = require("dko/panes")

local hidpi = wezterm.hostname() == "dotrakoun-mac"
  or wezterm.hostname() == "potatoair"

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

config.window_decorations = "RESIZE"
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
  -- :> :- :=

  -- Firple is Fira Code with IBM Plex Sans JP glyphs
  -- https://github.com/negset/Firple
  --  - https://github.com/tonsky/FiraCode
  --  - https://github.com/IBM/plex
  -- had some issues with some letters like E so back to fira code

  {
    family = "Maple Mono",
    harfbuzz_features = {
      "calt=0", -- no ligatures => ===
      "cv01", -- fully attached @ # $ etc.
      --"cv02", -- curly i
      "cv03", -- upper arm on a
      "cv04", -- @ rounded
      "ss05", -- {{}} tight
    },
  },

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

config.font_size = hidpi and 16.0 or 14.0

-- this is the default if using latest nightly
--config.front_end = "WebGpu"

-- Now that the default rasterizer is WebGpu, this looks funny
-- (at least using Vulkan). Check render of letter "f" in Maple Mono.
--config.freetype_load_flags = "NO_HINTING|NO_AUTOHINT"

config.line_height = 1.24

wezterm.on("augment-command-palette", function()
  return {
    {
      brief = "Balance panes horizontally",
      action = wezterm.action_callback(panes.balance("x")),
    },
    {
      brief = "Balance panes vertically",
      action = wezterm.action_callback(panes.balance("y")),
    },
  }
end)

config.keys = require("dko/mappings")
config.color_scheme = require("dko/theme").read()

return config

local wezterm = require("wezterm")

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

config.default_cursor_style = "BlinkingBlock"

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

require("dko/typography").setup(config)
require("dko/mappings").setup(config)
require("dko/theme").setup(config)
require("dko/panes").setup()

wezterm.on("gui-startup", function(cmd)
  local _tab, _pane, window = wezterm.mux.spawn_window(cmd or {})
  local w = window:gui_window()

  -- Maximize on start?
  -- w:maximize()

  -- =========================================================================
  -- DPI-based overrides
  -- =========================================================================
  local d = w:get_dimensions()
  wezterm.log_info("DPI: " .. d.dpi)

  local overrides = w:get_config_overrides() or {}

  local DPI_MAP = {
    [72] = 16,
    [96] = 12,
  }
  local override_size = DPI_MAP[d.dpi]
  if override_size ~= nil then
    overrides.font_size = override_size
    w:set_config_overrides(overrides)
  end
end)

return config

local wezterm = require("wezterm")

local M = {}

-- =============================================================================

M.setup = function(config)
  -- May be overridden on gui-startup -- see ./wezterm.lua
  config.font_size = 14.0

  -- ===========================================================================
  -- Fonts
  -- ===========================================================================

  -- Fix double-wide nerd fonts when using builtin Nerd Font Symbols
  config.allow_square_glyphs_to_overflow_width = "Never"

  config.adjust_window_size_when_changing_font_size = false

  config.command_palette_font_size = 24.0

  config.font = wezterm.font_with_fallback({
    -- For other font considerations see:
    -- https://github.com/davidosomething/dotfiles/issues/652

    -- == Primary Font =======================================================
    -- https://github.com/subframe7536/maple-font
    "Maple Mono Normal NL NF CN",
    -- =======================================================================

    -- == Smallcaps ==========================================================
    -- charset fallbacks ᴀʙᴄᴅᴇꜰɢʜɪᴊᴋʟᴍɴᴏᴘǫʀsᴛᴜᴠᴡxʏᴢ (ﾉಥ益ಥ）ﾉ︵┻━┻
    -- keep both of these -- has complete bold smallcaps that looks nicer than
    -- unifont
    "Noto Sans Mono", -- linux + smallcaps
    "Monaco", -- mac + smallcaps
    -- =======================================================================

    -- == Unicode ============================================================
    -- bitmap fallback with a lot of unicode, fork of unifont
    -- https://github.com/stgiga/UnifontEX
    {
      family = "UnifontExMono",
      scale = 1.2,
    },

    -- > WezTerm bundles JetBrains Mono, Nerd Font Symbols and Noto Color Emoji
    -- > fonts and uses those for the default font configuration.
    --   - https://wezterm.org/config/fonts.html#font-related-configuration
    -- The defaults are automatically appended.
    -- Use `wezterm ls-fonts` to see the final actual list of fonts used.
  })

  config.font_dirs = { "fonts" }

  -- this is the default if using latest nightly
  --config.front_end = "WebGpu"

  -- Now that the default rasterizer is WebGpu, this looks funny
  -- (at least using Vulkan). Check render of letter "f" in Maple Mono.
  --config.freetype_load_flags = "NO_HINTING|NO_AUTOHINT"

  config.line_height = 1.24
end

return M

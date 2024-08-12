-- Pull in the wezterm API
local wezterm = require("wezterm")

local hidpi = wezterm.hostname() == "dotrakoun-mac"

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

-- ===========================================================================
-- Theme
-- ===========================================================================

local xdg_state_home = os.getenv("XDG_STATE_HOME")
  or os.getenv("HOME") .. "/.local/state"
local colorscheme_file = ("%s/wezterm-colorscheme.txt"):format(xdg_state_home)

local notifier = "osascript -e 'display notification"
local close = "'"
if string.find(wezterm.target_triple, "linux") then
  notifier = "notify-send --app-name=WezTerm --urgency=low --expire-time=500"
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

---@param win table
local function toggle_colorscheme(win)
  local ecfg = win:effective_config()
  local next_mode = ecfg.color_scheme == colorschemes.light and "dark"
    or "light"
  local overrides = win:get_config_overrides() or {}
  local next_colorscheme = colorschemes[next_mode]
  overrides.color_scheme = next_colorscheme
  win:set_config_overrides(overrides)
  sync_colorscheme(next_mode)
end

--- Get panes that are on the same axis as the tab's active pane
---@param axis 'y'|'x'
---@param tab table
---@return table siblings
local function get_axis_siblings(axis, tab)
  local initial = tab:active_pane()
  local siblings = { initial }
  local prev_dir = axis == "x" and "Left" or "Up"
  local next_dir = axis == "x" and "Right" or "Down"

  local prev = tab:get_pane_direction(prev_dir)
  while prev do
    table.insert(siblings, 1, prev)
    prev:activate()
    prev = tab:get_pane_direction(prev_dir)
  end

  initial:activate() -- annoying
  local next = tab:get_pane_direction(next_dir)
  while next do
    table.insert(siblings, next)
    next:activate()
    next = tab:get_pane_direction(next_dir)
  end

  initial:activate() -- restore
  return siblings
end

--- Attempt to resize axis siblings to all the same size
---@param axis 'y'|'x'
local function balance_panes(axis)
  ---@param win table
  return function(win)
    local tab = win:active_tab()
    local initial = tab:active_pane()
    local prev_dir = axis == "x" and "Left" or "Up"
    local next_dir = axis == "x" and "Right" or "Down"
    local siblings = get_axis_siblings(axis, tab)
    local tab_size = tab:get_size()[axis == "x" and "cols" or "rows"]
    local balanced_size = math.floor(tab_size / #siblings)
    local pane_size_key = axis == "x" and "cols" or "viewport_rows"
    wezterm.log_info(
      string.format(
        "resizing %s panes on %s axis to %s cells",
        #siblings,
        axis,
        balanced_size
      )
    )

    for i, p in ipairs(siblings) do
      local pane_size = p:get_dimensions()[pane_size_key]
      local adj_amount = pane_size - balanced_size
      local adj_dir = adj_amount < 0 and next_dir or prev_dir
      adj_amount = math.abs(adj_amount)
      wezterm.log_info(
        string.format(
          "adjusting pane %s from %s by %s cells %s",
          tostring(i),
          tostring(pane_size),
          tostring(adj_amount),
          adj_dir
        )
      )

      -- This does not work if you spawn a new term
      -- os.execute(
      --   string.format(
      --     "wezterm cli adjust-pane-size --pane-id %s --amount %s %s",
      --     tostring(p:pane_id()),
      --     tostring(adj_amount),
      --     adj_dir
      --   )
      -- )
      p:activate()
      win:perform_action(
        -- AdjustPaneSize only acts on active pane
        wezterm.action.AdjustPaneSize({ adj_dir, adj_amount }),
        p -- this does not affect anything
      )
    end

    -- restore initial since we had to activate each pane to resize it
    initial:activate()
  end
end

wezterm.on("augment-command-palette", function()
  return {
    {
      brief = "Balance panes horizontally",
      action = wezterm.action_callback(balance_panes("x")),
    },
    {
      brief = "Balance panes vertically",
      action = wezterm.action_callback(balance_panes("y")),
    },
  }
end)

-- Change split behavior
-- If this is a middle split, default behavior
--    - you can use this to do regular half splits by jumping into prev window
--      and split from there
-- If there is no split in that direction split is halved
-- If there's an existing split in that direction then
--    split prev,curr,new evenly into thirds
--
---@param dir "Left"|"Up"
local scaled_split = function(dir)
  return function(win, pane)
    --wezterm.log_info("split " .. dir)
    local tab = win:active_tab()

    local opposite = dir == "Left" and "Right" or "Down"
    local next = tab:get_pane_direction(opposite)
    if not next then
      local size_key = dir == "Left" and "cols" or "viewport_rows"
      local prev = tab:get_pane_direction(dir)
      if prev then
        -- first resize the prev pane to be 1/3 vs 2/6
        -- then split this pane
        local prev_width = prev:get_dimensions()[size_key]
        local self_width = pane:get_dimensions()[size_key]
        local total_width = prev_width + self_width
        local onethird = math.floor(total_width / 3)

        -- if 1/3 is 26cols, and prev is 30 cols, we want to
        -- - grow pane by 4, i.e. shrink prev by 4
        local difference = prev_width < onethird and 0 or prev_width - onethird
        --wezterm.log_info(string.format('%s %s %s', onethird, prev_width, self_width))
        win:perform_action(
          wezterm.action.AdjustPaneSize({ dir, difference }),
          pane
        )
      end
    end

    pane:split({ direction = dir == "Left" and "Right" or "Bottom" })
  end
end

local split_horz = scaled_split("Left")
local split_vert = scaled_split("Up")

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
  action = wezterm.action_callback(toggle_colorscheme),
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
  action = wezterm.action_callback(split_horz),
})
k:insert({
  key = "0",
  mods = "CTRL|SHIFT",
  action = wezterm.action_callback(split_vert),
})
k:insert({
  key = "(",
  mods = "CTRL|SHIFT",
  action = wezterm.action_callback(split_horz),
})
k:insert({
  key = ")",
  mods = "CTRL|SHIFT",
  action = wezterm.action_callback(split_vert),
})

config.keys = k
return config

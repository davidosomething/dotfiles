local wezterm = require("wezterm")

--- Theme

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
  local file_handle = io.open(colorscheme_file, "w")
  if file_handle then
    os.execute(
      ('%s "updated %s with %s"%s'):format(
        notifier,
        colorscheme_file,
        next_mode,
        close
      )
    )
    file_handle:write(next_mode)
    file_handle:close()
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

local M = {}

---Sync the config with contents of the colorscheme_file
M.read = function()
  local file_handle = io.open(colorscheme_file, "r")
  if file_handle then
    local key = file_handle:read()
    file_handle:close()
    if key and colorschemes[key] then
      return colorschemes[key]
    end
  end

  -- fallback
  return colorschemes.dark
end

---@param win table
M.toggle = function(win)
  local ecfg = win:effective_config()
  local next_mode = ecfg.color_scheme == colorschemes.light and "dark"
    or "light"
  local overrides = win:get_config_overrides() or {}
  local next_colorscheme = colorschemes[next_mode]
  overrides.color_scheme = next_colorscheme
  win:set_config_overrides(overrides)
  sync_colorscheme(next_mode)
end

return M

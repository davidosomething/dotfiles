local notifier = require("dko/notifier")

--- Theme

local xdg_state_home = os.getenv("XDG_STATE_HOME")
  or os.getenv("HOME") .. "/.local/state"
local colorscheme_file = ("%s/wezterm-colorscheme.txt"):format(xdg_state_home)

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

---@param next_mode string
M.write = function(next_mode)
  local file_handle = io.open(colorscheme_file, "w")
  if file_handle then
    file_handle:write(next_mode)
    file_handle:close()
    local message = ("updated %s with %s"):format(colorscheme_file, next_mode)
    notifier.os(message)
    return
  end
  notifier.os(
    ("could not update %s with %s"):format(colorscheme_file, next_mode)
  )
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
  M.write(next_mode)
end

return M

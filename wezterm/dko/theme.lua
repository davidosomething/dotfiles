local notifier = require("dko/notifier")

--- Theme

local xdg_state_home = os.getenv("XDG_STATE_HOME")
  or os.getenv("HOME") .. "/.local/state"

---Other applications, such as neovim, may READ and watch for changes to this
---file
local colorscheme_file = ("%s/wezterm-colorscheme.txt"):format(xdg_state_home)

local themes = {
  dark = "Twilight (base16)",
  light = "Solarized (light) (terminal.sexy)",
}

local M = {}

---Sync the config with contents of the colorscheme_file
---@return string -- the name of a theme like "Twilight (base16)"
M.read = function()
  local file_handle, err, err_code = io.open(colorscheme_file, "r")
  if file_handle then
    local key = file_handle:read()
    file_handle:close()
    if key and themes[key] then
      return themes[key]
    end
  end

  --- "No such file or directory" is okay
  if err_code ~= 2 then
    notifier.os(("Error reading %s: %s"):format(colorscheme_file, err))
  end

  -- fallback
  return themes.dark
end

---@param next_mode string
M.write = function(next_mode)
  local file_handle, err = io.open(colorscheme_file, "w")
  if file_handle then
    file_handle:write(next_mode)
    file_handle:close()
    return
  end
  local reason = err or "Reason unknown"
  notifier.os(
    ("Could not update %s to %s: %s"):format(
      colorscheme_file,
      next_mode,
      reason
    )
  )
end

---@param win table
M.toggle = function(win)
  local ecfg = win:effective_config()
  local next_mode = ecfg.color_scheme == themes.light and "dark" or "light"
  local overrides = win:get_config_overrides() or {}
  local next_colorscheme = themes[next_mode]
  overrides.color_scheme = next_colorscheme
  win:set_config_overrides(overrides)
  M.write(next_mode)
end

M.setup = function(config)
  config.color_scheme = M.read()
end

return M

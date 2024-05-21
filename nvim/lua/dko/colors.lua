local M = {}

local settings = require("dko.settings")

M.is_dark = function()
  return vim.g.colors_name == settings.get("colors.dark")
end

M.is_light = function()
  return vim.g.colors_name == settings.get("colors.light")
end

M.lightmode = function()
  if M.is_light() then
    return
  end
  vim.o.bg = "light"
  vim.cmd.colorscheme(settings.get("colors.light"))
end

M.darkmode = function()
  if M.is_dark() then
    return
  end
  vim.o.bg = "dark"
  vim.cmd.colorscheme(settings.get("colors.dark"))
end

local colorscheme_file_path = ("%s/wezterm-colorscheme.txt"):format(
  vim.env.XDG_STATE_HOME or "~/.local/state"
)
M.apply_from_file = function()
  -- see ./bench/readfile.lua - io.input was consistently fastest for me
  local file = io.input(colorscheme_file_path)
  M[(file and (file:lines()()) or "dark") .. "mode"]()
end

local colorscheme_handle = nil
M.monitor_colorscheme = function()
  if colorscheme_handle ~= nil then
    return colorscheme_handle
  end

  colorscheme_handle = vim.uv.new_fs_event()
  if not colorscheme_handle then
    return nil
  end

  vim.uv.fs_event_start(
    colorscheme_handle,
    colorscheme_file_path,
    {},
    vim.schedule_wrap(M.apply_from_file)
  )

  return colorscheme_handle
end

M.wezterm_sync = function()
  M.apply_from_file()
  M.monitor_colorscheme()
end

return M

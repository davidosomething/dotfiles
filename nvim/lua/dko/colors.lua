local M = {}

M.lightmode = function()
  vim.o.bg = "light"
  vim.cmd("colorscheme " .. require("dko.settings").get("colors.light"))
end

M.darkmode = function()
  vim.o.bg = "dark"
  vim.cmd("colorscheme " .. require("dko.settings").get("colors.dark"))
end

local colorscheme_file_path = os.getenv("XDG_STATE_HOME")
  .. "/wezterm-colorscheme.txt"
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

  colorscheme_handle = vim.loop.new_fs_event()
  if not colorscheme_handle then
    return nil
  end

  vim.loop.fs_event_start(
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

M.reset_hlchunk = function()
  if package.loaded.hlchunk == nil then
    --vim.notify('reset_hlchunk not loaded')
    return
  end

  if
    not vim.tbl_contains(
      vim.tbl_values(require("dko.settings").get("colors")),
      vim.g.colors_name
    )
  then
    --vim.notify('reset_hlchunk colorscheme not ready')
    return
  end

  --vim.notify('reset_hlchunk init')
  require("hlchunk").setup({
    blank = {
      chars = { " " },
      enable = true,
      exclude_filetype = require("dko.utils.buffer").SPECIAL_FILETYPES,
      notify = false,
      style = {
        { bg = "", fg = "" },
        { bg = vim.g.colors_name == "meh" and "#242426" or "#f4f2ef" },
      },
    },
    chunk = {
      enable = true,
      exclude_filetypes = {
        sh = true
      },
      notify = false,
    },
    indent = { enable = false },
    line_num = { enable = false },
  })
end

return M

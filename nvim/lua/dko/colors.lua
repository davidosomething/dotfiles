local M = {}

M.lightmode = function()
  vim.o.bg = "light"
  vim.cmd("colorscheme " .. require("dko.settings").get("colors.light"))
end

M.darkmode = function()
  vim.o.bg = "dark"
  vim.cmd("colorscheme " .. require("dko.settings").get("colors.dark"))
end

M.indent_blankline = function()
  if vim.g.colors_name == "meh" then
    vim.cmd([[
              highlight IndentBlanklineIndent2 guibg=#242424 gui=nocombine
              highlight IndentBlanklineContextChar guifg=#664422 gui=nocombine
            ]])
  else -- two-firewatch
    vim.cmd([[
              highlight IndentBlanklineIndent2 guibg=#fafafa gui=nocombine
              highlight IndentBlanklineContextChar guifg=#eeeeee gui=nocombine
            ]])
  end
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

return M

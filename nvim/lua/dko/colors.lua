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
  --
  -- turns out readfile is faster
  -- when reading a single line (skip stat)
  -- and still synchronous
  --
  ---@diagnostic disable-next-line: missing-parameter
  -- local start_time = vim.fn.reltime() --[[@as number]]
  -- local fd = assert(vim.loop.fs_open(colorscheme_file_path, "r", 438))
  -- local stat = assert(vim.loop.fs_fstat(fd))
  -- local data = assert(vim.loop.fs_read(fd, stat.size, 0))
  -- vim.loop.fs_close(fd)
  ---@diagnostic disable-next-line: missing-parameter
  -- local elapsed_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
  -- vim.print(elapsed_time)

  ---@diagnostic disable-next-line: missing-parameter
  --start_time = vim.fn.reltime() --[[@as number]]
  local data = vim.fn.readfile(colorscheme_file_path, "", 1)
  M[(data[1] or "dark") .. "mode"]()
  ---@diagnostic disable-next-line: missing-parameter
  --elapsed_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
  --vim.print({ data, elapsed_time })
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

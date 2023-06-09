-- benchmark reading a single line (or just 5 chars) of a file

---@diagnostic disable: missing-parameter, param-type-mismatch, need-check-nil, unused-local
local function bench()
  local f, lines, line, start_time, elapsed_time

  start_time = vim.fn.reltime() --[[@as number]]
  f = io.open(os.getenv("MYVIMRC"), 'r')
  lines = f:lines()
  line = lines()
  elapsed_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
  vim.print(" io.open: " .. elapsed_time)
  f:close()

  start_time = vim.fn.reltime() --[[@as number]]
  f = io.input(os.getenv("MYVIMRC"))
  line = f:lines()()
  elapsed_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
  vim.print("io.input: " .. elapsed_time)
  f:close()

  start_time = vim.fn.reltime() --[[@as number]]
  vim.fn.readfile(os.getenv("MYVIMRC"), "", 1)
  elapsed_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
  vim.print("readfile: " .. elapsed_time)

  -- skip stat on the file, just check 5 bytes
  start_time = vim.fn.reltime() --[[@as number]]
  local fd = assert(vim.loop.fs_open(os.getenv("MYVIMRC"), "r", 438))
  line = vim.loop.fs_read(fd, 5)
  elapsed_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
  vim.print("      uv: " .. elapsed_time)
  vim.print()
  vim.loop.fs_close(fd)

end

-- the order in which they're called actually matters, so run multiple times
bench()
bench()
bench()
bench()
bench()
bench()

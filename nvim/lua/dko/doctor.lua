-- General info about current config and buffers

local M = {}

M.warnings = {}
M.errors = {}

--- Add an error
M.error = function(params)
  table.insert(M.errors, params)
end

--- Add a warning
M.warn = function(params)
  table.insert(M.warnings, params)
end

local tobuf = function(lines)
  vim.cmd("new")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.buftype = "nofile"
  vim.opt_local.filetype = "lua"
  vim.opt_local.readonly = true
  vim.opt_local.modified = false
end

M.get_all = function()
  return vim.split(
    vim.inspect({
      errors = require("dko.doctor").errors,
      warnings = require("dko.doctor").warnings,
    }),
    "\n",
    { plain = true }
  )
end

M.get_errors = function()
  return vim.split(
    vim.inpsect({ errors = require("dko.doctor").errors }),
    "\n",
    { plain = true }
  )
end

M.get_warnings = function()
  return vim.split(
    vim.inspect({ warnings = require("dko.doctor").warnings }),
    "\n",
    { plain = true }
  )
end

---@type integer
local floatwin = -1

M.show_float = function()
  local LISTED = false
  local SCRATCH = true
  local buf = vim.api.nvim_create_buf(LISTED, SCRATCH)

  local START = 0
  local END = -1
  local STRICT_INDEXING = false
  vim.api.nvim_buf_set_lines(buf, START, END, STRICT_INDEXING, M.get_all())

  local position = {
    relative = "editor",
    anchor = "NE",
    col = vim.o.columns,
    row = 1,
  }
  local size = {
    height = 16,
    width = 48,
  }
  local opts = vim.tbl_extend("force", {
    style = "minimal",
    border = "single",
    title = "  doctor ",
    title_pos = "right",
  }, position, size)
  local ENTER = false
  floatwin = vim.api.nvim_open_win(buf, ENTER, opts)
  vim.api.nvim_set_option_value(
    "wrap",
    true,
    { scope = "local", win = floatwin }
  )
end

M.close_float = function()
  if M.is_float_open() then
    vim.api.nvim_win_close(floatwin, true)
    floatwin = -1
  end
end

M.is_float_open = function()
  if floatwin > -1 and vim.api.nvim_win_is_valid(floatwin) then
    return true
  end
  floatwin = -1
  return false
end

M.enter_float = function()
  if M.is_float_open() then
    vim.api.nvim_set_current_win(floatwin)
  end
end

--- Open float if not open
--- Enter float if open and not focused
--- Close float if currently inside it
M.toggle_float = function()
  if M.is_float_open() then
    if vim.api.nvim_get_current_win() ~= floatwin then
      return M.enter_float()
    end
    return M.close_float()
  end
  return M.show_float()
end

local subcommands = {
  errors = function()
    tobuf(M.get_errors())
  end,
  warnings = function()
    tobuf(M.get_warnings())
  end,
  all = function()
    tobuf(M.get_all())
  end,
}

---@return string[]
local complete = function(--[[ ArgLead, CmdLine, CursorPos ]])
  return vim.tbl_keys(subcommands)
end

vim.api.nvim_create_user_command("DKODoctor", function(opts)
  local handler = subcommands[opts.args] or subcommands.all
  handler()
end, {
  desc = "DKODoctor errors and warnings",
  nargs = "*",
  complete = complete,
})

return M

local dkoicons = require("dko.icons")

---@class DKODoctorEntry
---@field category string
---@field message string

local M = {}

---@type DKODoctorEntry[]
M.warnings = {}

---@type DKODoctorEntry[]
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
  -- vim.opt_local.filetype = "lua"
  vim.opt_local.readonly = true
  vim.opt_local.modified = false
end

M.get_all = function()
  local output = {}

  local errors = M.get_errors()
  if #errors > 0 then
    table.insert(output, ("%s ᴇʀʀᴏʀs"):format(dkoicons.Error))
    table.insert(output, table.concat(errors, "\n"))
  end

  local warnings = M.get_warnings()
  if #warnings > 0 then
    table.insert(output, ("%s ᴡᴀʀɴɪɴɢs"):format(dkoicons.Warn))
    table.insert(output, table.concat(warnings, "\n"))
  end

  if #errors + #warnings == 0 then
    table.insert(output, ("%s ᴀʟʟ ɢᴏᴏᴅ"):format(dkoicons.Ok))
  end

  return output
end

M.get_errors = function()
  return vim
    .iter(M.errors)
    :map(function(entry)
      return ("%s %s"):format(dkoicons.Bullet, entry.message)
    end)
    :totable()
end

M.get_warnings = function()
  return vim
    .iter(M.warnings)
    :map(function(entry)
      return ("%s %s"):format(dkoicons.Bullet, entry.message)
    end)
    :totable()
end

---@type integer
local floatwin = -1

M.show_float = function()
  local LISTED = false
  local SCRATCH = true
  local buf = vim.api.nvim_create_buf(LISTED, SCRATCH)
  -- vim.api.nvim_set_option_value("filetype", "lua", { buf = buf })

  local START = 0
  local END = -1
  local STRICT_INDEXING = false

  local contents = M.get_all()
  vim.api.nvim_buf_set_lines(buf, START, END, STRICT_INDEXING, contents)

  local position = {
    relative = "editor",
    anchor = "NE",
    col = vim.o.columns,
    row = 1,
  }
  local size = {
    height = math.max(math.min(#contents, vim.o.lines), 1),
    width = math.max(math.floor(vim.o.columns / 2), 1),
  }
  local opts = vim.tbl_extend("force", {
    style = "minimal",
    border = "single",
    title = "  ᴅᴏᴄᴛᴏʀ ",
    title_pos = "right",
  }, position, size)
  local ENTER = false
  floatwin = vim.api.nvim_open_win(buf, ENTER, opts)
  vim.api.nvim_set_option_value(
    "wrap",
    true,
    { scope = "local", win = floatwin }
  )
  vim.api.nvim_set_option_value(
    "winfixbuf",
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

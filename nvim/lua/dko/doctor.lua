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

local subcommands = {
  errors = function()
    tobuf(
      vim.split(
        vim.inpsect({ errors = require("dko.doctor").errors }),
        "\n",
        { plain = true }
      )
    )
  end,
  warnings = function()
    tobuf(
      vim.split(
        vim.inspect({ warnings = require("dko.doctor").warnings }),
        "\n",
        { plain = true }
      )
    )
  end,
  all = function()
    tobuf(vim.split(
      vim.inspect({
        errors = require("dko.doctor").errors,
        warnings = require("dko.doctor").warnings,
      }),
      "\n",
      { plain = true }
    ))
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

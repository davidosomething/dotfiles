-- Debugging flags
local TRACE = false
if TRACE then
  vim.lsp.set_log_level("trace")
  require("vim.lsp.log").set_format_func(vim.inspect)
else
  vim.lsp.set_log_level("INFO")
end

-- ===========================================================================
-- LSP Notifications
-- ===========================================================================

---@alias MessageType
---| 1 # Error
---| 2 # Warning
---| 3 # Info
---| 4 # Log

---@alias LogLevel
---| 0 # TRACE
---| 1 # DEBUG
---| 2 # INFO
---| 3 # WARN
---| 4 # ERROR
---| 5 # OFF

local M = {}

---Convert an LSP MessageType to a vim.notify log level
---@param mt MessageType https://github.com/neovim/neovim/blob/7ef5e363d360f86c5d8d403e90ed256f4de798ec/runtime/lua/vim/lsp/protocol.lua
---@return LogLevel level https://github.com/neovim/neovim/blob/master/runtime/lua/vim/_editor.lua#L44-L53
M.lsp_messagetype_to_vim_log_level = function(mt)
  local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[mt]
  return vim.log.levels[lvl]
end

M.bind_notify = function()
  ---Show LSP messages via vim.notify (but only when using nvim-notify)
  ---https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/handlers.lua
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.handlers["window/showMessage"] = function(_, result, ctx, _)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local client_name = client and client.name or ctx.client_id
    local title = ("LSP > %s"):format(client_name)
    if not client then
      vim.notify(result.message, vim.log.levels.ERROR, { title = title })
    else
      local level = M.lsp_messagetype_to_vim_log_level(result.type)
      vim.notify(result.message, level, { title = title })
    end
    return result
  end
end

return M

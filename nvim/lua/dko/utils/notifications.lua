local M = {}

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

---Convert an LSP MessageType to a vim.notify log level
---@param mt MessageType https://github.com/neovim/neovim/blob/7ef5e363d360f86c5d8d403e90ed256f4de798ec/runtime/lua/vim/lsp/protocol.lua#L50-L60
---@return LogLevel level https://github.com/neovim/neovim/blob/master/runtime/lua/vim/_editor.lua#L44-L53
M.lsp_messagetype_to_vim_log_level = function(mt)
  local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[mt]
  return vim.log.levels[lvl]
end

---Convert native vim.notify messages to nvim-notify
---@param notify function|table
M.override_builtin = function(notify)
  ---@param msg string
  ---@param level? number vim.log.levels.*
  ---@param opts? table
  local override = function(msg, level, opts)
    if not opts then
      opts = {}
    end
    if not opts.title then
      if require("dko.utils.string").starts_with(msg, "[LSP]") then
        msg = msg:gsub("^%[LSP%]", "")
        opts.title = "LSP"
      elseif msg == "No code actions available" then
        -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#LL629C39-L629C39
        opts.title = "LSP"
        opts.render = "compact"
      end
    end
    notify(msg, level, opts)
  end
  vim.notify = override
end

M.override_lsp = function()
  ---Show LSP messages via vim.notify (but only when using nvim-notify)
  ---https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/handlers.lua#L524-L541
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.handlers["window/showMessage"] = function(_, result, ctx, _)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local level = M.lsp_messagetype_to_vim_log_level(result.type)
    vim.notify(result.message, level, {
      title = "LSP | " .. client.name,
      keep = function()
        return result.type == vim.lsp.protocol.MessageType.Error
          or result.type == vim.lsp.protocol.MessageType.Warning
      end,
    })
  end
end

return M

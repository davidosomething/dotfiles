-- LSP floating window borders
-- Add default rounded border and suppress no info messages
-- E.g. used by /usr/share/nvim/runtime/lua/vim/lsp/handlers.lua
-- To see example of this fn used, press K for LSP hover
-- Overriding with vim.lsp.with is the way recommended by docs (as opposed to
-- overriding vim.lsp.util.open_floating_preview entirely)

local toast = require("dko.utils.notify").toast

local lsp = vim.lsp
local handlers = lsp.handlers
local Methods = lsp.protocol.Methods

local config = {
  border = require("dko.settings").get("border"),
  silent = true,
}

handlers[Methods.textDocument_hover] = lsp.with(handlers.hover, config)

handlers[Methods.textDocument_signatureHelp] =
  lsp.with(handlers.signature_help, config)

---@alias dkonotify.MessageType
---| 1 # Error
---| 2 # Warning
---| 3 # Info
---| 4 # Log

---@alias dkonotify.LogLevel
---| 0 # TRACE
---| 1 # DEBUG
---| 2 # INFO
---| 3 # WARN
---| 4 # ERROR
---| 5 # OFF

---Convert an LSP MessageType to a vim.notify vim.log.levels int
---@param mt dkonotify.MessageType https://github.com/neovim/neovim/blob/7ef5e363d360f86c5d8d403e90ed256f4de798ec/runtime/lua/vim/lsp/protocol.lua#L50-L60
---@return dkonotify.LogLevel level https://github.com/neovim/neovim/blob/master/runtime/lua/vim/_editor.lua#L59-L69
local function lsp_messagetype_to_vim_log_level(mt)
  local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[mt]
  return vim.log.levels[lvl]
end

---Show LSP messages via toast (default is vim.notify or nvim_out_write)
-- https://github.com/neovim/neovim/blob/199d852d9f8584217be38efb56b725aa3db62931/runtime/lua/vim/lsp/handlers.lua#L635-L654
handlers[Methods.window_showMessage] = function(_, result, ctx, _)
  local client = lsp.get_client_by_id(ctx.client_id)
  local client_name = client and client.name or ctx.client_id
  local title = ("[LSP] %s"):format(client_name)
  if not client then
    toast(result.message, vim.log.levels.ERROR, { title = title })
  else
    local level = lsp_messagetype_to_vim_log_level(result.type)
    toast(result.message, level, { title = title })
  end
  return result
end

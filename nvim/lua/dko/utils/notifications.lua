local M = {}

local function starts_with(haystack, needle)
  return string.sub(haystack, 1, string.len(needle)) == needle
end

-- Convert native vim.notify messages to nvim-notify
M.override_builtin = function(notify)
  local override = function(msg, level, opts)
    if not opts then
      opts = {}
    end
    if not opts.title then
      if starts_with(msg, "[LSP]") then
        msg = msg:gsub("^%[LSP%]", "")
        opts.title = "LSP"
      end
    end
    notify(msg, level, opts)
  end
  vim.notify = override
end

M.override_lsp = function()
  -- Show LSP messages via vim.notify (but only when using nvim-notify)
  ---@see https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/handlers.lua#L524-L541
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.handlers["window/showMessage"] = function(_, result, ctx, _)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
    vim.notify(result.message, vim.log.levels[lvl], {
      title = "LSP | " .. client.name,
      keep = function()
        return result.type == vim.lsp.protocol.MessageType.Error
          or result.type == vim.lsp.protocol.MessageType.Warning
      end,
    })
  end
end

return M

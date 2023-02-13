local M = {}

M.format_buffer = function(options)
  options = vim.tbl_deep_extend('force', options or {}, {
    async = false,
    filter = function(client)
      if not client.supports_method("textDocument/formatting") then
        return false
      end

      -- =====================================================================
      -- Filetype specific choices
      -- @TODO move this somewhere better
      -- =====================================================================

      if vim.bo.filetype == "lua" and client.name == "lua_ls" then
        vim.notify("Skipping lua_ls", "info", { title = "LSP" })
        return false
      end

      if
        vim.bo.filetype == "typescript"
        or vim.bo.filetype == "typescriptreact" and client.name == "tsserver"
      then
        vim.notify("Formatting with tsserver", "info", { title = "LSP" })
        return true
      end

      -- =====================================================================

      vim.notify("Formatting with " .. client.name, "info", { title = "LSP" })
      return true
    end,
  })

  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L147-L187
  vim.lsp.buf.format(options)
end

return M

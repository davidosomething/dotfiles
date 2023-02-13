local M = {}

M.format_buffer = function(options)
  options = vim.tbl_deep_extend("force", options or {}, {
    filter = function(client)
      if not client.supports_method("textDocument/formatting") then
        return false
      end

      -- =====================================================================
      -- Filetype specific choices
      -- @TODO move this somewhere better
      -- =====================================================================

      if vim.tbl_contains({ "lua_ls", "tsserver" }, client.name) then
        vim.notify(
          "Skipping " .. client.name .. " formatting",
          "info",
          { title = "LSP" }
        )
        return false
      end

      -- =====================================================================
      -- My null-ls runtime_condition will notify
      -- =====================================================================

      if client.name ~= "null-ls" then
        vim.notify("Formatting with " .. client.name, "info", { title = "LSP" })
      end

      return true
    end,
  })

  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L147-L187
  vim.lsp.buf.format(options)
end

return M

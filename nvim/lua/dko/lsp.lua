local M = {}

M.format = function(options)
  if
    vim.tbl_contains(
      { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      vim.bo.filetype
    )
  then
    -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/eslint.lua#L152-L159
    vim.cmd("EslintFixAll")
    return
  end

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
        vim.notify({
          "Skipping " .. client.name .. " formatting",
          "via lua/dko/lsp.lua",
        }, "info", { title = "LSP" })
        return false
      end

      -- =====================================================================
      -- My null-ls runtime_condition will notify
      -- =====================================================================

      if client.name ~= "null-ls" then
        vim.notify({
          "Formatting with " .. client.name,
          "via lua/dko/lsp.lua",
        }, "info", { title = "LSP" })
      end

      return true
    end,
  })

  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L147-L187
  vim.lsp.buf.format(options)
end

return M

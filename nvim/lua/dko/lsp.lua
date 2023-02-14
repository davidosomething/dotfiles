local M = {}

local notify_opts = {
  title = "LSP",
  render = "compact",
}

M.null_ls_notify_on_format = function(params)
  local source = params:get_source()
  vim.notify(
    "null-ls[" .. source.name .. "] format",
    vim.log.levels.INFO,
    notify_opts
  )
end

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
        vim.notify(
          client.name .. " disabled in dko/lsp.lua",
          vim.log.levels.INFO,
          notify_opts
        )
        return false
      end

      -- =====================================================================
      -- My null-ls runtime_condition will notify
      -- =====================================================================

      if client.name ~= "null-ls" then
        vim.notify(client.name .. " format", vim.log.levels.INFO, notify_opts)
      end

      return true
    end,
  })

  -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/buf.lua#L147-L187
  vim.lsp.buf.format(options)
end

return M

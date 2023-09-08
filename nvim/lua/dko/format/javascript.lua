-- NO eslint-plugin-prettier? maybe run prettier
-- then, maybe run eslint --fix
return function(notify)
  vim.b.has_eslint = vim.b.has_eslint
    or #vim.lsp.get_clients({ bufnr = 0, name = "eslint" }) > 0

  if vim.b.has_eslint then
    if vim.b.has_eslint_plugin_prettier == nil then
      vim.b.has_eslint_plugin_prettier =
        require("dko.node").has_eslint_plugin("prettier")
    end

    vim.cmd.EslintFixAll()

    if vim.b.has_eslint_plugin_prettier then
      vim.notify("format with eslint-plugin-prettier", vim.log.levels.INFO, {
        render = "compact",
        title = "LSP > eslint",
      })
      return
    end

    notify({ "eslint" })
  end

  require("dko.format.efm").format()
end

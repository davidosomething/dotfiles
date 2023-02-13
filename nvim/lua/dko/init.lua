local M = {}

M.autofix = function()
  if
    vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact"
  then
    vim.schedule(function()
      local ok, typescript = pcall(require, "typescript")
      if ok then
        typescript.actions.removeUnused({ sync = true })
        typescript.actions.addMissingImports({ sync = true })
        typescript.actions.organizeImports({ sync = true })
        -- more like fixMisc, fixes things like unreachable code
        typescript.actions.fixAll({ sync = true })
        vim.notify("typescript.actions", "info", { title = "LSP" })
      end
    end)
  end

  vim.schedule(function()
    require("dko.lsp").format_buffer({ async = false })
  end)

  if
    vim.bo.filetype == "typescript"
    or vim.bo.filetype == "typescriptreact"
    or vim.bo.filetype == "javascript"
    or vim.bo.filetype == "javascriptreact"
  then
    vim.schedule(function()
      local ok = pcall(vim.cmd.EslintFixAll)
      if ok then
        vim.notify("EslintFixAll", "info", { title = "LSP" })
      end
    end)
  end
end

return M

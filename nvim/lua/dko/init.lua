local M = {}

M.autofix = function()
  if
    vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact"
  then
    local ok, typescript = pcall(require, "typescript")
    if ok then
      vim.schedule(function()
        typescript.actions.removeUnused({ sync = true })
      end)
      vim.schedule(function()
        typescript.actions.addMissingImports({ sync = true })
      end)
      vim.schedule(function()
        typescript.actions.organizeImports({ sync = true })
      end)
      vim.schedule(function()
        vim.notify("typescript.actions", "info", { title = "LSP" })
      end)
    end
  end

  vim.schedule(function()
    require("dko.lsp").format_buffer()
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

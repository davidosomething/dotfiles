local M = {}

M.autofix = function()
  if
    vim.bo.filetype == "typescript" or vim.bo.filetype == "typescriptreact"
  then
    local ok, typescript = pcall(require, "typescript")
    if ok then
      typescript.actions.removeUnused({ sync = true })
      typescript.actions.addMissingImports({ sync = true })
      typescript.actions.organizeImports({ sync = true })
    end
  end

  require("dko.lsp").format_buffer()
end

return M

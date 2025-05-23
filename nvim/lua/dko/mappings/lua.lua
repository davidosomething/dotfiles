local Methods = vim.lsp.protocol.Methods

local M = {}

M.bind_gf = function()
  require("dko.mappings").map("n", "gf", function()
    local line = vim.api.nvim_get_current_line()
    if line:match("require%(") then
      local bufnr = vim.api.nvim_get_current_buf()
      local has_definition_handler = #vim.lsp.get_clients({
        bufnr = bufnr,
        method = Methods.textDocument_definition,
      }) > 0
      if has_definition_handler then
        return "gd"
      end
    end
  end, {
    buffer = true,
    desc = "[ft.lua] Use gd if lsp bound and line contains 'require('",
    expr = true,
    remap = true, -- follow into gd mapping
  })
end

return M

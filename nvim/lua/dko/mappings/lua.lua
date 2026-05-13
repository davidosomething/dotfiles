local M = {}

M.bind_gf = function()
  require("dko.mappings").map("n", "gf", function()
    --- if WORD looks like a filepath, just hop to it
    local cword = vim.fn.expand("<cWORD>")
    if cword:match("/") or cword:match("%.%w+$") then
      return "gf"
    end

    --- if in a require(), try to resolve definition
    local line = vim.api.nvim_get_current_line()
    if line:match("require%(") then
      local bufnr = vim.api.nvim_get_current_buf()
      local has_definition_handler = #vim.lsp.get_clients({
        bufnr = bufnr,
        method = "textDocument/definition",
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

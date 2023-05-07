local M = {}

M.indent_blankline = function()
  if vim.g.colors_name == "meh" then
    vim.cmd([[
              highlight IndentBlanklineIndent2 guibg=#242424 gui=nocombine
              highlight IndentBlanklineContextChar guifg=#664422 gui=nocombine
            ]])
  else
    vim.cmd([[
              highlight IndentBlanklineIndent2 guibg=#fafafa gui=nocombine
              highlight IndentBlanklineContextChar guifg=#eeeeee gui=nocombine
            ]])
  end
end

return M

local M = {}

local next = {
  line_mode = "display_mode",
  display_mode = "line_mode",
}

M.line_mode = function()
  vim.b.movemode = "line_mode"
  print("Move by real newlines")
  pcall(vim.keymap.del, "n", "j", { buffer = true })
  pcall(vim.keymap.del, "n", "k", { buffer = true })
end

-- Move by display lines unless a count is given
-- https://bluz71.github.io/2017/05/15/vim-tips-tricks.html
M.display_mode = function()
  vim.b.movemode = "display_mode"
  print("Move by display lines")
  vim.keymap.set("n", "j", function()
    if vim.v.count > 0 then
      return "j"
    else
      return "gj"
    end
  end, { buffer = true, expr = true })
  vim.keymap.set("n", "k", function()
    if vim.v.count > 0 then
      return "k"
    else
      return "gk"
    end
  end, { buffer = true, expr = true })
end

M.toggle = function()
  M[next[vim.b.movemode] or "display_mode"]()
end

return M

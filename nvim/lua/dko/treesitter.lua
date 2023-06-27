local M = {}

M.is_treesitter_enabled = function(bufnr)
  bufnr = bufnr or 0

  if vim.fn.bufexists(bufnr) == 0 then
    return false
  end

  local ft = vim.bo[bufnr].filetype
  if ft == "" then
    return false
  end

  local alias = require("dko.settings").get("treesitter.aliases")[ft]
  local lang = alias or ft
  return require("nvim-treesitter.configs").is_enabled("highlight", lang, bufnr)
end

return M

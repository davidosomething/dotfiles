local M = {}

M.shorten = function(filepath, amount)
  -- GIVEN '/abc/123/def/345/file.tsx'

  -- '/abc/123/def/345'
  -- '123/def/345' if you are already in /abc
  local short_ancestors = vim.fn.fnamemodify(filepath, ":~:.:h")
  -- '12/de/34'
  short_ancestors = vim.fn.pathshorten(short_ancestors, amount)
  -- '12/de'
  short_ancestors = vim.fn.fnamemodify(short_ancestors, ":h")

  -- '345'
  local parent_dir = vim.fn.fnamemodify(filepath, ":p:h:t")

  -- file.tsx
  local just_filename = vim.fn.fnamemodify(filepath, ":t")

  return ("%s/%s/%s"):format(short_ancestors, parent_dir, just_filename)
end

return M

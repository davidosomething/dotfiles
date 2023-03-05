local M = {}

M.SPECIAL_BUFTYPES = {
  "help",
  "nofile",
  "popup",
  "prompt",
  "quickfix",
  "terminal",
}

---@param bufnr integer
M.is_special = function(bufnr)
  -- @TODO might need this back, recreate SPECIAL_FILETYPES
  -- local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')

  local bt = vim.api.nvim_buf_get_option(bufnr, 'buftype')
  if vim.tbl_contains(M.SPECIAL_BUFTYPES, bt) then
    return true
  end
  return false
end

---@param bufnr integer
M.is_editable = function(bufnr)
  -- buffer not editable at all
  local modifiable = vim.api.nvim_buf_get_option(bufnr, 'modifiable')

  -- buffer editable, :w locked
  local readonly = vim.api.nvim_buf_get_option(bufnr, 'readonly')

  return modifiable and not readonly and not M.is_special(bufnr)
end

M.get_cursorline_contents = function()
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  return vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
end

return M

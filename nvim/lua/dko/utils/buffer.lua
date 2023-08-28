local M = {}

M.SPECIAL_BUFTYPES = {
  "help",
  "nofile",
  "popup",
  "prompt",
  "quickfix",
  "terminal",
}

M.SPECIAL_FILETYPES = {
  "fugitive",
  "gitcommit",
  "gitrebase",
  "lazy",
  "mason",
}

---@param bufnr integer
M.is_special = function(bufnr)
  return vim.list_contains(M.SPECIAL_BUFTYPES, vim.bo[bufnr].buftype)
    or vim.list_contains(M.SPECIAL_FILETYPES, vim.bo[bufnr].filetype)
end

---@param bufnr integer
M.is_editable = function(bufnr)
  return vim.bo[bufnr].modifiable -- modifiable - buffer not editable at all
    and not vim.bo[bufnr].readonly -- readonly - buffer editable, :w locked
    and not M.is_special(bufnr)
end

local HIGHLIGHTING_MAX_FILESIZE = 300 * 1024 -- 300 KB

---@param query string|table can be a filename or a { bufnr }
---@return boolean|nil true if filesize is bigger than HIGHLIGHTING_MAX_FILESIZE
M.is_huge = function(query)
  local filename = query
  if type(query) == "table" and query.bufnr then
    filename = vim.api.nvim_buf_get_name(query.bufnr)
  end
  local ok, stats = pcall(vim.uv.fs_stat, filename)
  return ok and stats and stats.size > HIGHLIGHTING_MAX_FILESIZE
end

M.get_cursorline_contents = function()
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  return vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
end

---Close quickfix and loclist, then switch any active windows, then delete
---buffer from buffer list
M.close = function()
  vim.cmd.cclose()
  vim.cmd.lclose()
  local ok, bufremove = pcall(require, "mini.bufremove")
  if ok then
    bufremove.delete(nil, true)
  else
    vim.cmd.bdelete({ bang = true })
  end
end

return M

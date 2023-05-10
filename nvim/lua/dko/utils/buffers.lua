---
-- Operations on multiple buffers
---

local M = {}

---@param bufnrs table like vim.api.nvim_list_bufs()
---@return table only modified
M.filter_modified = function(bufnrs)
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_buf_get_option(bufnr, "modified")
  end, bufnrs)
end

---@param bufnrs table like vim.api.nvim_list_bufs()
---@return table only special
M.filter_special = function(bufnrs)
  return vim.tbl_filter(function(bufnr)
    return require('dko.utils.buffer').is_special(bufnr)
  end, bufnrs)
end

return M

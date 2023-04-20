local M = {}

M.toggle = function(opts)
  opts = vim.tbl_extend("keep", opts or {}, {
    focus = true
  })

  local original_window_count = #vim.api.nvim_tabpage_list_wins(0)
  local original_winnr = vim.api.nvim_get_current_win()

  vim.cmd.lclose()
  local did_close_loclist = #vim.api.nvim_tabpage_list_wins(0) ~= original_window_count
  if not did_close_loclist then
    -- Opens ONLY if loclist is populated
    vim.cmd.lwindow()
  end

  if opts.focus then
    vim.api.nvim_set_current_win(original_winnr)
  end
end

return M

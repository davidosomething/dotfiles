local M = {}

--- Toggle loclist open or closed
---@param opts? { focus?: boolean }
M.toggle = function(opts)
  opts = vim.tbl_extend("keep", opts or {}, { focus = true })

  local num_windows = #vim.api.nvim_tabpage_list_wins(0)
  local original_winnr = vim.api.nvim_get_current_win()

  vim.cmd.lclose()

  --- if number of windows changed, a loclist was actually closed
  local did_close_loclist = #vim.api.nvim_tabpage_list_wins(0) ~= num_windows
  if did_close_loclist then
    return
  end

  local loclist_count = #vim.fn.getloclist(original_winnr)
  local should_try_open = loclist_count > 0
  if should_try_open then
    vim.cmd.lwindow()
    if opts.focus then
      vim.api.nvim_set_current_win(original_winnr)
    end
  end
end

return M

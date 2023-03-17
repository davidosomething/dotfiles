-- From https://github.com/wookayin/dotfiles/blob/eb2633d756ec6b2119ab9b4a229744a9e6485359/vim/vimrc#L1012
local function close_floats()
  local closed_windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then -- is_floating_window?
      vim.api.nvim_win_close(win, false) -- do not force
      table.insert(closed_windows, win)
    end
  end
  if #closed_windows > 0 then
    print(
      ("Closed %d windows: %s"):format(
        #closed_windows,
        vim.inspect(closed_windows)
      )
    )
  end
end

return close_floats

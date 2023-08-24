local M = {}

-- From https://github.com/wookayin/dotfiles/blob/eb2633d756ec6b2119ab9b4a229744a9e6485359/vim/vimrc#L1012
M.close_floats = function()
  vim
    .iter(vim.api.nvim_list_wins())
    :filter(function(win)
      local config = vim.api.nvim_win_get_config(win)
      return config.relative ~= "" -- non floating_window only
    end)
    :each(function(win)
      vim.api.nvim_win_close(win, false) -- do not force
    end)
end

return M

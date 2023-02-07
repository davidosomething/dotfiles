-- This is a command run by ~/.dotfiles/bin/e before sending events to
-- existing server (e.g. --remote-send files to edit)
vim.api.nvim_create_user_command(
  'DKOExternal',
  function()
    -- Close window if it is relative (floating, like an FTerm)
    if vim.api.nvim_win_get_config(0).relative then
      vim.api.nvim_win_close(0, false)
    end
  end,
  { desc = "Prepare to receive an external command" }
)

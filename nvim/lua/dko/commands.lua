-- ===========================================================================
-- Commands
-- ===========================================================================

local command = vim.api.nvim_create_user_command

command("Q", "q", { bang = true, desc = ":Q same as :q" })

-- This is a command run by ~/.dotfiles/bin/e before sending events to
-- existing server (e.g. --remote-send files to edit)
command("DKOExternal", function()
  require("dko.utils.close_floats")()
end, { desc = "Prepare to receive an external command" })

command("Delete", function()
  local fp = vim.api.nvim_buf_get_name(0)

  vim.cmd.cclose()
  vim.cmd.lclose()

  local ok, err = vim.loop.fs_unlink(fp)
  if not ok then
    vim.notify(
      table.concat({ fp, err }, "\n"),
      vim.log.levels.ERROR,
      { title = ":Delete failed" }
    )
    vim.cmd.edit()
  else
    vim.cmd.bdelete()
  end

end, { desc = "Delete current file" })

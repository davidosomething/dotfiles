-- ===========================================================================
-- Commands
-- ===========================================================================

local command = vim.api.nvim_create_user_command

command("Q", "q", { bang = true, desc = ":Q same as :q" })

-- ===========================================================================

-- This is a command run by ~/.dotfiles/bin/e before sending events to
-- existing server (e.g. --remote-send files to edit)
command("DKOExternal", function()
  require("dko.utils.close_floats")()
end, { desc = "Prepare to receive an external command" })

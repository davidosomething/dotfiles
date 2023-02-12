local close_floats = require("dko.utils.close_floats")

-- This is a command run by ~/.dotfiles/bin/e before sending events to
-- existing server (e.g. --remote-send files to edit)
vim.api.nvim_create_user_command("DKOExternal", function()
  close_floats()
end, { desc = "Prepare to receive an external command" })

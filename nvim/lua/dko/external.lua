local closeFloats = require("dko.utils.closeFloats")

-- This is a command run by ~/.dotfiles/bin/e before sending events to
-- existing server (e.g. --remote-send files to edit)
vim.api.nvim_create_user_command("DKOExternal", function()
  closeFloats()
end, { desc = "Prepare to receive an external command" })

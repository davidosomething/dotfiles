local smallcaps = require("dko.utils.string").smallcaps

-- neovim supports built-in osc52 as of
--  https://github.com/neovim/neovim/pull/25872/files
-- and it is used if we are on a remote connection by default as of
--  https://github.com/neovim/neovim/pull/26064/files
--
-- BUT i'm gonna *force* using it and the unnamedplus
if require("dko.utils.clipboard").should_use_osc52() then
  if vim.g.clipboard then
    -- already using a plugin?
    return
  end

  local tag = vim.env.SSH_TTY and " (" .. smallcaps("ssh") .. ")" or ""

  -- neovim automatically does this as long as 'clipboard' is not set
  vim.g.clipboard = {
    name = (smallcaps("osc") .. "52%s"):format(tag),
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    -- wezterm no paste support yet
    -- https://github.com/wez/wezterm/issues/2050
    paste = {
      --   ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      --   ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }

  -- add this now
  vim.o.clipboard = "unnamedplus"
end

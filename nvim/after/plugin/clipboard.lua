-- Too lazy to switch registers, just use system plus as default
vim.o.clipboard = "unnamedplus"

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

  local dkostring = require("dko.utils.string")
  local tag = vim.env.SSH_TTY and (" (%s)"):format(dkostring.smallcaps("ssh"))
    or ""

  -- neovim automatically does this as long as 'clipboard' is not set
  local vim_osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = ("%s52%s"):format(dkostring.smallcaps("osc"), tag),
    copy = {
      ["+"] = vim_osc52.copy("+"),
      ["*"] = vim_osc52.copy("*"),
    },
    -- wezterm no paste support yet
    -- https://github.com/wez/wezterm/issues/2050
    paste = {
      ["+"] = function() end,
      ["*"] = function() end,
    },
  }
end

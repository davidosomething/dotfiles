-- supports built-in osc52?
-- https://github.com/neovim/neovim/pull/25872/files
if
  vim.clipboard
  and vim.clipboard.osc52
  and require("dko.utils.vte").is_remote()
then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.clipboard.osc52").copy,
      ["*"] = require("vim.clipboard.osc52").copy,
    },
    paste = {
      ["+"] = require("vim.clipboard.osc52").paste,
      ["*"] = require("vim.clipboard.osc52").paste,
    },
  }
end

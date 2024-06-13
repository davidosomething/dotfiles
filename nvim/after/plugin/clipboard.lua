-- neovim supports built-in osc52 as of
--  https://github.com/neovim/neovim/pull/25872/files
-- and it is used if we are on a remote connection by default as of
--  https://github.com/neovim/neovim/pull/26064/files
-- When NOT being used, prefer unnamedplus (system) clipboard
if require("dko.utils.clipboard").should_use_osc52() then
  if vim.g.clipboard then
    -- already using a plugin?
    return
    -- else it should automatically use OSC 52 according to :h clipboard-osc52
  end
else
  vim.o.clipboard = "unnamedplus"
end

-- neovim supports built-in osc52 as of
--  https://github.com/neovim/neovim/pull/25872/files
-- and it is used if we are on a remote connection by default as of
--  https://github.com/neovim/neovim/pull/26064/files
-- When NOT being used, prefer unnamedplus (system) clipboard
if not vim.clipboard or not vim.g.clipboard then
  vim.o.clipboard = "unnamedplus"
end

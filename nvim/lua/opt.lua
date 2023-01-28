vim.opt.clipboard = 'unnamedplus'

-- Bumped '100 to '1000 to save more previous files
-- Bumped <50 to <100 to save more register lines
-- Bumped s10 to s100 for to allow up to 100kb of data per item
vim.opt.shada = "!,'1000,<100,s100,h"

-- New neovim feature, it's like vim-over but hides the thing being replaced
-- so it is not practical for now (makes it harder to remember what you're
-- replacing/reference previous regex tokens). Default is off, but explicitly
-- disabled here, too.
-- https://github.com/neovim/neovim/pull/5226
vim.opt.inccommand = ''

-- Swap write and CursorHold timeout
-- Pretty quick... errorprone on old vim so only apply to nvim
vim.opt.updatetime = 250

-- Prior versions are super dangerous
if not vim.fn.has('patch-8.1.1365') and not vim.fn.has('nvim-0.3.6') then
  vim.opt.modeline = false
else
  -- Only check one line
  if vim.fn.exists('+modelines') then
    vim.opt.modelines = 1
  end
end

if vim.fn.exists('+pyxversion') and vim.fn.has('python3') then
  vim.opt.pyxversion = 3
end

-- ===========================================================================
-- Display
-- ===========================================================================

vim.opt.title = true -- wintitle = filename - vim

vim.opt.number = true
vim.opt.numberwidth = 5

-- show context around current cursor position
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 16

vim.opt.textwidth = 78
-- the line will be right after column 80, &tw+3
vim.opt.colorcolumn = { '+3', '120' }
vim.opt.cursorline = true

vim.opt.synmaxcol = 512 -- don't syntax highlight long lines

vim.opt.clipboard = 'unnamedplus'

vim.opt.timeout = false -- don't wait

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

if vim.fn.exists('+signcolumn') then
  vim.opt.signcolumn = vim.fn.has('nvim-0.4') and 'auto:3' or 'yes'
end

vim.opt.showtabline = 0 -- start OFF, toggle =2 to show tabline

-- This is slow on some terminals and often gets hidden by msgs so leave it off
vim.opt.showcmd = false
vim.opt.showmode = false -- don't show -- INSERT -- in cmdline

-- ===========================================================================
-- Wild and file globbing stuff in command mode
-- ===========================================================================

vim.opt.browsedir = 'buffer' -- browse files in same dir as open file
vim.opt.wildmode = 'list:longest,full'
vim.opt.wildignorecase = true

-- ===========================================================================
-- File saving
-- ===========================================================================

vim.opt.fileformats = 'unix,mac,dos'

-- If we have a swap conflict, FZF has issues opening the file (and doesn't
-- prompt correctly)
vim.opt.swapfile = false

-- writebackup: use backup files when writing (create new file, replace old
-- one with new one)
-- Disabled for coc.nvim compat!
-- https://github.com/neoclide/coc.nvim/blob/f96b4364335760cb942ef73853d5f038b265ff16/README.md#example-lua-configuration
-- https://github.com/neoclide/coc.nvim/issues/649
vim.opt.writebackup = false
vim.opt.backup = false -- do not leave around backup.xyz~ files after that

-- need this for webpack-dev-server and hot module reloading -- preserves
-- special file types like symlinks
vim.opt.backupcopy = 'yes'

vim.opt.backupskip:append('/private/tmp/*') -- needed to edit crontab files
vim.opt.backupskip:append('~/.secret/*')

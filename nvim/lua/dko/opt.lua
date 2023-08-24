vim.go.termguicolors = os.getenv("TERM_PROGRAM") ~= "Apple_Terminal"

-- ===========================================================================
-- File reading
-- ===========================================================================

vim.o.modelines = 1
vim.o.undofile = true

-- ===========================================================================
-- File saving
-- ===========================================================================

-- Bumped '100 to '1000 to save more previous files
-- Bumped <50 to <100 to save more register lines
-- Bumped s10 to s100 for to allow up to 100kb of data per item
vim.o.shada = "!,'1000,<100,s100,h"

vim.o.fileformats = "unix,mac,dos"

-- writebackup: use backup files when writing (create new file, replace old
-- one with new one)
vim.o.writebackup = false
vim.o.backup = false -- do not leave around backup.xyz~ files after that

-- need this for webpack-dev-server and hot module reloading -- preserves
-- special file types like symlinks
vim.o.backupcopy = "yes"

vim.opt.backupskip:append("/private/tmp/*") -- needed to edit crontab files
vim.opt.backupskip:append("~/.secret/*")
vim.o.clipboard = "unnamedplus"

-- ===========================================================================
-- Display
-- ===========================================================================

vim.o.timeout = false -- don't wait

-- Swap write and CursorHold timeout
-- Pretty quick... errorprone on old vim so only apply to nvim
vim.o.updatetime = 250

vim.o.title = true -- wintitle = filename - vim

vim.o.number = true
vim.o.numberwidth = 5

-- show context around current cursor position
vim.o.scrolloff = 8
vim.o.sidescrolloff = 16

-- min 1, max 4 signs
vim.o.signcolumn = "auto:1-4"

vim.o.synmaxcol = 512 -- don't syntax highlight long lines

vim.o.textwidth = 78

-- the line will be right after column 80, &tw+3
vim.opt.colorcolumn = { "+3", "120" }
vim.o.cursorline = true

vim.o.ruler = false

vim.o.showtabline = 0 -- start OFF, toggle =2 to show tabline

-- This is slow on some terminals and often gets hidden by msgs so leave it off
vim.o.showcmd = false
vim.o.showmode = false -- don't show -- INSERT -- in cmdline

-- like vim-over but hides the thing being replaced so it is not practical for
-- now (makes it harder to remember what you're replacing/reference previous
-- regex tokens).
-- https://github.com/neovim/neovim/pull/5226
vim.o.inccommand = ""

-- ===========================================================================
-- Wild and file globbing stuff in command mode
-- ===========================================================================

--vim.o.browsedir = "buffer" -- browse files in same dir as open file
vim.o.wildmode = "list:longest,full"
vim.o.wildignorecase = true

-- ===========================================================================
-- Built-in completion
-- ===========================================================================

-- Don't consider = symbol as part filename.
vim.opt.isfname:remove("=")

vim.opt.complete:remove("t") -- don't complete tags

vim.opt.completeopt:remove("longest")
vim.opt.completeopt:append("menuone") -- show PUM, even for one thing
vim.opt.completeopt:append("noinsert")
vim.opt.completeopt:append("noselect")
vim.opt.completeopt:remove("preview") -- don't open scratch

-- ===========================================================================
-- Message output on vim actions
-- ===========================================================================

vim.opt.shortmess:append({
  c = true, -- Disable "Pattern not found" messages
  m = true, -- use "[+]" instead of "[Modified]"
  r = true, -- use "[RO]" instead of "[readonly]"
  I = true, -- don't give the intro message when starting Vim |:intro|.
  S = true, -- hide search info echoing (i have a statusline for that)
  W = true, -- don't give "written" or "[w]" when writing a file
})

-- ===========================================================================
-- Window splitting and buffers
-- ===========================================================================

vim.o.splitbelow = true
vim.o.splitright = true
vim.o.hidden = true

-- reveal already opened files from the quickfix window instead of opening new
-- buffers
vim.o.switchbuf = "useopen"

-- ===========================================================================
-- Code folding
-- ===========================================================================

vim.o.foldlevel = 999 -- very high === all folds open
vim.o.foldlevelstart = 99 -- show all folds by default
vim.o.foldenable = false

-- ===========================================================================
-- Trailing whitespace
-- ===========================================================================

vim.o.list = true
vim.opt.listchars = {
  extends = "»",
  nbsp = "⣿",
  precedes = "«",
  trail = "·",
  -- removed tab, it's too noisy
  tab = "  ", -- this must be two chars, see :h listchars
}

-- ===========================================================================
-- Diffing
-- ===========================================================================

vim.opt.fillchars = { diff = "⣿" }
vim.opt.diffopt = {
  vertical = true, -- Use in vertical diff mode
  filler = true, -- blank lines to keep sides aligned
  iwhite = true, -- Ignore whitespace changes
}

-- ===========================================================================
-- Input auto-formatting (global defaults)
-- Probably need to update these in after/ftplugin too since ftplugins will
-- probably update it.
-- ===========================================================================

vim.opt.formatoptions = {
  j = true, -- remove comment leader on join comments
  n = true, -- Recognize numbered lists
  q = true, -- allow gq to format comments
  o = true, -- continue comment using o or O
  r = true, -- Continue comments by default
  a = false, -- auto-gq paragraphs
  l = false, -- break lines that are already long?
}
vim.opt.formatoptions:append("1") -- Break before 1-letter words
vim.opt.formatoptions:append("2") -- Use indent from 2nd line of a paragraph

vim.o.wrap = false
vim.o.joinspaces = false -- J command doesn't add extra space

-- ===========================================================================
-- Indenting - overridden by indent plugins
-- ===========================================================================

-- For autoindent, use same spaces/tabs mix as previous line, even if
-- tabs/spaces are mixed. Helps for docblock, where the block comments have a
-- space after the indent to align asterisks
--
-- The test case what happens when using o/O and >> and << on these:
--     /**
--      *
-- Refer also to formatoptions+=o (copy comment indent to newline)
vim.o.copyindent = false

-- Try not to change the indent structure on "<<" and ">>" commands. I.e. keep
-- block comments aligned with space if there is a space there.
vim.o.preserveindent = false

-- Smart detect when in braces and parens. Has annoying side effect that it
-- won't indent lines beginning with '#'. Relying on syntax indentexpr instead.
-- 'smartindent' in general is a piece of garbage, never turn it on.
vim.o.smartindent = false

-- Global setting. I don't edit C-style code all the time so don't default to
-- C-style indenting.
vim.o.cindent = false

-- ===========================================================================
-- Tabbing - overridden by editorconfig, after/ftplugin
-- ===========================================================================

-- use multiple of shiftwidth when shifting indent levels.
-- this is OFF so block comments don't get fudged when using ">>" and "<<"
vim.o.shiftround = false

-- ===========================================================================
-- Match and search
-- ===========================================================================

vim.o.matchtime = 1 -- tenths of a sec
vim.o.showmatch = false -- briefly jump to matching paren?
vim.o.wrapscan = true -- Searches wrap around end of the file.
vim.o.ignorecase = true
vim.o.smartcase = true
-- Follow smartcase and ignorecase when doing tag search
vim.o.tagcase = "followscs"

-- ===========================================================================
-- grep
-- ===========================================================================

local grepper = (
  vim.fn.executable(require("dko.grepper.rg").command) == 1
    and require("dko.grepper.rg")
  or vim.fn.executable(require("dko.grepper.ag").command) == 1 and require(
    "dko.grepper.ag"
  )
  or vim.fn.executable(require("dko.grepper.ack").command) == 1
    and require("dko.grepper.ack")
)
if grepper then
  vim.o.grepprg = ("%s %s"):format(
    grepper.command,
    table.concat(grepper.options, " ")
  )
  vim.o.grepformat = grepper.format
end

-- ===========================================================================
-- netrw
-- ===========================================================================

vim.g.netrw_altfile = 1 -- never altfile back to netrw
vim.g.netrw_hide = 0 -- show all files
vim.g.netrw_liststyle = 3 -- netrw in details format when no vimfiler
vim.g.netrw_browsex_viewer = "dko-open"

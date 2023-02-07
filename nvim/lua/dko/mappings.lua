local map = vim.keymap.set

-- ===========================================================================
-- Window / Buffer manip
-- ===========================================================================

map('n', '<Leader>x', '<Cmd>lclose<CR><Cmd>bp|bd #<CR>', {
  desc = 'Close buffer without destroying window',
})

map('n', '<BS>', '<C-^>', {
  desc = 'Prev buffer with <BS> backspace in normal (C-^ is kinda awkward)',
})

local resizeOpts = {
  desc = 'Resize window with Shift+DIR, can take a count #<S-Dir>',
}
map('n', '<S-Up>', '<C-W>+', resizeOpts)
map('n', '<S-Down>', '<C-W>-', resizeOpts)
map('n', '<S-Left>', '<C-w><', resizeOpts)
map('n', '<S-Right>', '<C-w>>', resizeOpts)

-- ===========================================================================
-- Switch mode
-- ===========================================================================

local leaderLeaderOpts = {
  desc = "Toggle visual/normal mode with space-space",
}
map('n', '<Leader><Leader>', 'V', leaderLeaderOpts)
map('x', '<Leader><Leader>', '<Esc>', leaderLeaderOpts)

map({ 'c', 'i' }, 'jj', '<Esc>', {
  desc = "Back to normal mode",
})

-- ===========================================================================
-- Visual mode tweaks
-- ===========================================================================

local visualArrowOpts = {
  desc = "Visual move by display lines"
}
map('v', '<Down>', 'gj', visualArrowOpts)
map('v', '<Up>', 'gk', visualArrowOpts)

-- ===========================================================================
-- cd shortcuts
-- ===========================================================================

map('n', '<Leader>cd', '<Cmd>cd! %:h<CR>', {
  desc = "cd to current buffer path",
})

map('n', '<Leader>..', '<Cmd>cd! ..<CR>', {
  desc = "cd up a level",
})

map('n', '<Leader>cr',
  function() vim.fn.chdir(vim.fn['dko#project#GetRoot']()) end,
  { desc = "cd to current buffer's git root" }
)

-- ===========================================================================
-- :edit shortcuts
-- ===========================================================================
map('n', '<Leader>ecr', "<Cmd>call dko#edit#EditClosest('README.md')<CR>", {
  desc = 'Edit closest README.md',
})
map('n', '<Leader>epj', "<Cmd>call dko#edit#EditClosest('package.json')<CR>", {
  desc = 'Edit closest package.json',
})
map('n', '<Leader>evi', "<Cmd>edit " .. vim.g.vdotdir .. '/init.lua<CR>', {
  desc = 'Edit init.lua'
})
map('n', '<Leader>evm', "<Cmd>edit " .. vim.g.vdotdir .. '/lua/dko/mappings.lua<CR>', {
  desc = 'Edit mappings.lua'
})
map('n', '<Leader>evp', "<Cmd>edit " .. vim.g.vdotdir .. '/lua/dko/lazy/plugins.lua<CR>', {
  desc = 'Edit plugins.lua'
})

-- ===========================================================================
-- Buffer: Reading
-- ===========================================================================

map({ 'i', 'n' }, '<F1>', '<NOP>', {
  desc = 'Disable help shortcut key',
})

map('n', '<F1>', require('dko.help'), {
  desc = "Show vim help for <cexpr>",
})

-- ===========================================================================
-- Buffer: Movement
-- ===========================================================================

map('', 'H', '^', {
  desc = 'Change H to alias ^',
})
map('', 'L', 'g_', {
  desc = 'Change L to alias g_',
})

-- https://stackoverflow.com/questions/4256697/vim-search-and-highlight-but-do-not-jump#comment91750564_4257175
map('n', '*', 'm`<Cmd>keepjumps normal! *``<CR>', {
  desc = "Don't jump on first * -- simpler vim-asterisk",
})


-- ===========================================================================
-- Buffer: Edit contents
-- ===========================================================================

local visualTabOpts = {
  desc = "<Tab> indents selected lines in Visual",
  remap = true,
}
map('v', '<Tab>', '>', visualTabOpts)
map('v', '<S-Tab>', '<', visualTabOpts)

map('n', '<Leader>q', '@q', {
  desc = "Quickly apply macro q",
})

local reselectOpts = { desc = "Reselect visual block after indent" }
map('x', '<', '<gv', reselectOpts)
map('x', '>', '>gv', reselectOpts)

map('n', '<Leader>,', '$r,', {
  desc = "Replace last character with a comma"
})
map('n', '<Leader>;', '$r;', {
  desc = "Replace last character with a semi-colon",
})

map('n', '<Leader>ws',
  function() vim.fn['dko#whitespace#clean']() end,
  { desc = "Remove trailing whitespace from entire file", }
)

-- https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-288
map('n', '<Leader>s', 'vip<Cmd>sort<CR>', {
  desc = "Auto select paragraph (bounded by blank lines) and sort",
})
map('x', '<Leader>s', '<Cmd>sort<CR>', {
  desc = "Sort selection",
})


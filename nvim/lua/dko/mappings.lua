-- ===========================================================================
-- mappings.lua
-- Terminal mappings are in terminal.lua
-- ===========================================================================

-- Move to different window
vim.keymap.set('n', '<A-Up>', '<C-w>k')
vim.keymap.set('n', '<A-Down>', '<C-w>j')
vim.keymap.set('n', '<A-Left>', '<C-w>h')
vim.keymap.set('n', '<A-Right>', '<C-w>l')
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-j>', '<C-w>j')
vim.keymap.set('n', '<A-h>', '<C-w>h')
vim.keymap.set('n', '<A-l>', '<C-w>l')

-- Open terminal
vim.keymap.set('n', '<Leader>vt', ':<C-U>vsplit term://$SHELL<CR>A')

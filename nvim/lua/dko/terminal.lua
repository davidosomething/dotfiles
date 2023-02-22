-- ===========================================================================
-- :terminal
-- ===========================================================================

vim.g.terminal_scrollback_buffer_size = 100000

-- Use gruvbox's termcolors
-- https://github.com/ianks/gruvbox/blob/c7b13d9872af9fe1f5588d6ec56759489b0d7864/colors/gruvbox.vim#L137-L169
-- https://github.com/morhetz/gruvbox/pull/93/files

-- dark0 + gray
vim.g.terminal_color_0 = "#282828"
vim.g.terminal_color_8 = "#928374"

-- neurtral_red + bright_red
vim.g.terminal_color_1 = "#cc241d"
vim.g.terminal_color_9 = "#fb4934"

-- neutral_green + bright_green
vim.g.terminal_color_2 = "#98971a"
vim.g.terminal_color_10 = "#b8bb26"

-- neutral_yellow + bright_yellow
vim.g.terminal_color_3 = "#d79921"
vim.g.terminal_color_11 = "#fabd2f"

-- neutral_blue + bright_blue
vim.g.terminal_color_4 = "#458588"
vim.g.terminal_color_12 = "#83a598"

-- neutral_purple + bright_purple
vim.g.terminal_color_5 = "#b16286"
vim.g.terminal_color_13 = "#d3869b"

-- neutral_aqua + faded_aqua
vim.g.terminal_color_6 = "#689d6a"
vim.g.terminal_color_14 = "#8ec07c"

-- light4 + light1
vim.g.terminal_color_7 = "#a89984"
vim.g.terminal_color_15 = "#ebdbb2"

vim.keymap.set("t", "<C-b>", "<C-\\><C-n>", {
  desc = "Get back to vim mode",
  silent = true,
})

-- Move between windows using Alt-
-- Ctrl- works only outside of terminal buffers
vim.keymap.set("t", "<A-Up>", "<C-\\><C-n><C-w>k", { silent = true })
vim.keymap.set("t", "<A-Down>", "<C-\\><C-n><C-w>j", { silent = true })
vim.keymap.set("t", "<A-Left>", "<C-\\><C-n><C-w>h", { silent = true })
vim.keymap.set("t", "<A-Right>", "<C-\\><C-n><C-w>l", { silent = true })

vim.keymap.set(
  "n",
  "<Leader>vt",
  "<Cmd>vsplit term://$SHELL<CR>A",
  { desc = "Open terminal in a vsplit" }
)

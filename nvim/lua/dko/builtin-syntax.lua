-- $VIMRUNTIME syntax indent settings

-- markdown
-- Variable to highlight markdown fenced code properly -- uses tpope's
-- vim-markdown plugin (which is bundled with vim7.4 now)
-- There are more syntaxes, but checking for them makes editing md very slow
vim.g.markdown_fenced_languages = {
  "javascript",
  "js=javascript",
  "javascriptreact",
  "json",
  "bash=sh",
  "sh",
  "vim",
  "help",
}

-- php
-- Additional syntax groups for php baselib
vim.g.php_baselib = true
-- Highlight unclosed ([]) - from $VIMRUNTIME/syntax/php.vim
vim.g.php_parentError = true

-- $VIMRUNTIME/indent/php.vim and 2072/
-- Don't indent after <?php opening
vim.g.PHP_default_indenting = false
-- Don't outdent the <?php tags to the first column
vim.g.PHP_outdentphpescape = false

-- python
-- $VIMRUNTIME/syntax/python.vim
vim.g.python_highlight_all = 1

-- sh
-- $VIMRUNTIME/syntax/sh.vim - always assume bash
vim.g.is_bash = 1

-- vim
-- $VIMRUNTIME/syntax/vim.vim
-- disable mzscheme, tcl highlighting
vim.g.vimsyn_embed = "lpPr"

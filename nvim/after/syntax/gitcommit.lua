-- Use ; for gitcommit comments instead of # since I write markdown in my gitcommits
vim.cmd.syntax('clear gitcommitComment "^#.*"')
vim.cmd.syntax('match gitcommitComment "^;.*"')

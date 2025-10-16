---like vim.bo but can table:append with it
vim.opt_local.complete:append({ "kspell" })

vim.bo.comments = ":;"
--- ensure `gcc` formats properly
vim.bo.commentstring = "; %s"

vim.bo.swapfile = false
vim.bo.textwidth = 80

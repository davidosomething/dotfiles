---like vim.bo but can table:append with it
vim.opt_local.complete:append({ "kspell" })

vim.bo.comments = ":;"
--- ensure `gcc` formats properly
vim.bo.commentstring = "; %s"

vim.bo.swapfile = false
vim.bo.textwidth = 80

--- committia#open has a BufReadPost autocmd, but it may fire before lazy.nvim
--- sources start plugins in giteditor context. Ensure it opens explicitly.
if vim.g.loaded_committia == 1 then
  pcall(vim.fn["committia#open"], "git")
end

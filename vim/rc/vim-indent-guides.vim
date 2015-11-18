let g:indent_guides_color_change_percent = 2

" Must be recursive maps
nmap <silent> <F6> <Plug>IndentGuidesToggle
imap <silent> <F6> <Esc>:IndentGuidesToggle<CR>a

autocmd vimrc   BufEnter *.php,*.html   IndentGuidesEnable
autocmd vimrc   BufLeave *.php,*.html   IndentGuidesDisable


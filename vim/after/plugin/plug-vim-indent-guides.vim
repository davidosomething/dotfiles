if !exists('g:plugs["vim-indent-guides"]') | finish | endif

let g:indent_guides_color_change_percent = 2

" Must be recursive maps
nmap <silent> <F6> <Plug>IndentGuidesToggle
imap <silent> <F6> <Esc>:IndentGuidesToggle<CR>a

autocmd vimrc   BufEnter  *.hbs,*.html,*.mustache,*.php   IndentGuidesEnable
autocmd vimrc   BufLeave  *.hbs,*.html,*.mustache,*.php   IndentGuidesDisable


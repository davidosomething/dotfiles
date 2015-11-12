let g:pdv_template_dir = expand(g:dko_vim_dir . g:dko_plugdir . "/pdv/templates")
autocmd vimrc FileType php nnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>
autocmd vimrc FileType php vnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>

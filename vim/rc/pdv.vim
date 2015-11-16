let g:pdv_template_dir = expand(g:dko_vim_dir . g:dko_plugdir . "/pdv/templates")
autocmd vimrc FileType php nnoremap <buffer> <Leader>pd :call pdv#DocumentCurrentLine()<CR>
autocmd vimrc FileType php vnoremap <buffer> <Leader>pd :call pdv#DocumentCurrentLine()<CR>

let g:pdv_template_dir = expand("$VIM_DOTFILES/plugged/pdv/templates")
autocmd vimrc FileType php nnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>
autocmd vimrc FileType php vnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>

if has("gui_macvim")
  set anti
  set guioptions-=T                   " hide stupid toolbar
  set backupcopy=yes                  " keep finder labels!
  set colorcolumn=80

  " open current doc as Markdown in Marked.app
  " http://captainbollocks.tumblr.com/post/9858989188/linking-macvim-and-marked-app
  nnoremap <leader>m :silent !open -a Marked.app '%:p'<cr>
endif

let g:indent_guides_enable_on_vim_startup = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local config
if filereadable("~/.vimrc.local")
  source ~/.vimrc.local
endif

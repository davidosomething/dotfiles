if has("gui_macvim")
  set anti
  set guioptions-=T                   " hide stupid toolbar
  set backupcopy=yes                  " keep finder labels!
  set colorcolumn=80

  " only applies to buffers containing a markdown file
  " open current doc as Markdown in Marked.app
  " http://captainbollocks.tumblr.com/post/9858989188/linking-macvim-and-marked-app
  au filetype markdown nnoremap <buffer><leader>m :silent !open -a Marked.app '%:p'<cr>
endif

let g:indent_guides_enable_on_vim_startup = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local config
if filereadable("~/.vimrc.local")
  source ~/.vimrc.local
endif

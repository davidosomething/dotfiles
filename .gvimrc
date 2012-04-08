set guioptions-=m                     " hide file/edit/etc. menu
set guioptions-=T                     " hide stupid button bar

let g:indent_guides_enable_on_vim_startup = 1

if has("gui_macvim")
  set anti
  set backupcopy=yes                  " keep finder labels!
  set colorcolumn=80

  " only applies to buffers containing a markdown file
  " open current doc as Markdown in Marked.app
  " http://captainbollocks.tumblr.com/post/9858989188/linking-macvim-and-marked-app
  au filetype markdown nnoremap <buffer><leader>m :silent !open -a Marked.app '%:p'<cr>

else " linux only
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local config
if filereadable($HOME . "/.gvimrc.local")
  source ~/.gvimrc.local
endif

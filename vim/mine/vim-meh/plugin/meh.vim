augroup vim-meh
  autocmd!
augroup END

let s:truecolor = has('termguicolors') && &termguicolors
      \ && $TERM_PROGRAM !=# 'Apple_Terminal'

if s:truecolor
  autocmd vim-meh ColorScheme * call meh#LineColors()
endif

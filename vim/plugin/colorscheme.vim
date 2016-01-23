" plugin/colorscheme.vim

let s:use_solarized = 1
      \ && has('gui_running')
      \ && exists("g:plugs['vim-colors-solarized']")

if s:use_solarized

  " turn off gross italics -- fira sans happens to use ligatures too
  let g:solarized_italic  = 0
  let g:solarized_menu    = 0

  colorscheme solarized
  set background=light

else " terminal vim

  if &t_Co == 256
    if exists("g:plugs['gruvbox']")
      colorscheme gruvbox
    elseif exists("g:plugs['seoul256.vim']")
      let g:seoul256_background=234
      colorscheme seoul256
    endif
  else
    colorscheme delek
  endif

  set background=dark

endif


" plugin/colorscheme.vim

if has('nvim') && exists("g:plugs['oceanic-next']")

  colorscheme OceanicNext
  set background=dark

elseif has('gui_running') && exists("g:plugs['vim-colors-solarized']")

  " turn off gross italics -- fira sans happens to use ligatures too
  let g:solarized_italic  = 0
  let g:solarized_menu    = 0

  colorscheme solarized
  call togglebg#map('<F5>')
  set background=light

else

  " terminal vim

  if &t_Co == 256 && exists("g:plugs['seoul256.vim']")
    let g:seoul256_background=234
    colorscheme seoul256
  else
    colorscheme delek
  endif

  set background=dark

endif


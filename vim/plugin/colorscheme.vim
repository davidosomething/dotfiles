" plugin/colorscheme.vim

if has('gui_running') && exists("g:plugs['vim-colors-solarized']")

  " turn off gross italics -- fira sans happens to use ligatures too
  let g:solarized_italic  = 0
  let g:solarized_menu    = 0

  colorscheme solarized
  call togglebg#map('<F5>')
  set background=light

elseif exists("g:plugs['base16-vim']")

  colorscheme base16-tomorrow
  set background=dark

else

  colorscheme pablo

endif


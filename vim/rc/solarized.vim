if has('gui_running')
  " turn off gross italics -- fira sans happens to use ligatures too
  let g:solarized_italic = 0
  set background=light

  " STFU if no solarized
  silent! colorscheme solarized
  silent! call togglebg#map("<F5>")
endif

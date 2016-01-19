if !exists("g:plugs['vim-colors-solarized']") | finish | endif

" turn off gross italics -- fira sans happens to use ligatures too
let g:solarized_italic  = 0
let g:solarized_menu    = 0

try
  call togglebg#map('<F5>')
  colorscheme solarized
catch
endtry

set background=light


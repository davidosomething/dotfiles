if !exists("g:plugs['vim-colors-solarized']") | finish | endif
if !has("gui_running") | finish | endif

" turn off gross italics -- fira sans happens to use ligatures too
let g:solarized_italic  = 0
let g:solarized_menu    = 0

try
  colorscheme solarized
  call togglebg#map('<F5>')
catch
endtry

set background=light


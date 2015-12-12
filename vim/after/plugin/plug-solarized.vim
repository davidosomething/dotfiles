if !exists("g:plugs['vim-colors-solarized']")
      \ && !exists("g:plugs['neovim-colors-solarized-truecolor-only']")
  finish
endif

" turn off gross italics -- fira sans happens to use ligatures too
let g:solarized_italic = 0

call togglebg#map('<F5>')
colorscheme solarized
set background=light

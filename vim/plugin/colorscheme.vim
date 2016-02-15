" plugin/colorscheme.vim

let s:use_solarized = 1
      \ && has('gui_running')
      \ && exists("g:plugs['vim-colors-solarized']")

if s:use_solarized

  " turn off gross italics -- fira sans happens to use ligatures too
  let g:solarized_italic  = 0
  let g:solarized_menu    = 0

  silent! colorscheme solarized
  set background=light

else " terminal vim

  if &t_Co != 256
    silent! colorscheme delek
  endif

  if exists('g:plugs["gruvbox"]')
    let g:gruvbox_contrast_dark      = 'hard'
    let g:gruvbox_contrast_light     = 'hard'
    let g:gruvbox_italic = 1
    let g:gruvbox_italicize_comments = 0
    let g:gruvbox_invert_selection   = 0
    silent! colorscheme gruvbox
  elseif exists('g:plugs["Sierra"]')
    let g:sierra_Midnight = 1
    silent! colorscheme sierra
  endif

  set background=dark

endif


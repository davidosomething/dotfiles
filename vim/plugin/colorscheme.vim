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
    if exists("g:plugs['vim-hybrid']")
      " let g:hybrid_custom_term_colors = 1
      " let g:hybrid_reduced_contrast   = 1
      colorscheme hybrid
    elseif exists("g:plugs['gruvbox']")
      let g:gruvbox_contrast_dark      = 'hard'
      let g:gruvbox_contrast_light     = 'hard'
      let g:gruvbox_italicize_comments = 0
      let g:gruvbox_invert_selection   = 0
      colorscheme gruvbox
    elseif exists("g:plugs['seoul256.vim']")
      let g:seoul256_background = 234
      colorscheme seoul256
    endif
  else
    colorscheme delek
  endif

  set background=dark

endif


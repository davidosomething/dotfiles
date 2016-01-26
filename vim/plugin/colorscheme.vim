" plugin/colorscheme.vim

let s:use_solarized = 1
      \ && has('gui_running')
      \ && exists("g:plugs['vim-colors-solarized']")
      \ && !empty(glob(expand(g:dko_plug_absdir . '/vim-colors-solarized/colors/solarized.vim')))

if s:use_solarized

  " turn off gross italics -- fira sans happens to use ligatures too
  let g:solarized_italic  = 0
  let g:solarized_menu    = 0

  silent! colorscheme solarized
  set background=light

else " terminal vim

  if &t_Co == 256
    if exists("g:plugs['vim-hybrid']")
          \ && !empty(glob(expand(g:dko_plug_absdir . '/vim-hybrid/colors/hybrid.vim')))
      " let g:hybrid_custom_term_colors = 1
      " let g:hybrid_reduced_contrast   = 1
      silent! colorscheme hybrid
    elseif exists("g:plugs['gruvbox']")
          \ && !empty(glob(expand(g:dko_plug_absdir . '/gruvbox/colors/gruvbox.vim')))
      let g:gruvbox_contrast_dark      = 'hard'
      let g:gruvbox_contrast_light     = 'hard'
      let g:gruvbox_italicize_comments = 0
      let g:gruvbox_invert_selection   = 0
      silent! colorscheme gruvbox
    elseif exists("g:plugs['seoul256.vim']")
          \ && !empty(glob(expand(g:dko_plug_absdir . '/seoul256.vim/colors/seoul256.vim')))
      let g:seoul256_background = 234
      silent! colorscheme seoul256
    endif
  else

    colorscheme delek

  endif

  set background=dark

endif


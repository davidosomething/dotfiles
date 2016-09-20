" plugin/colorscheme.vim

try
  " ============================================================================
  " gui
  " ============================================================================

  let s:use_solarized = 1
        \ && has('gui_running')
        \ && dko#IsPlugged('vim-colors-solarized')

  if s:use_solarized
    let g:solarized_italic  = 0
    let g:solarized_menu    = 0
    silent! colorscheme solarized
    set background=light
    finish

  " ============================================================================
  " terminal / fallbacks
  " ============================================================================

  elseif dko#IsPlugged('Base2Tone-vim')
    silent! colorscheme Base2Tone-Lake-dark
    set background=dark
    finish

  elseif dko#IsPlugged('vim-two-firewatch')
    let g:two_firewatch_italics = 1
    silent! colorscheme two-firewatch
    set background=dark
    finish

  elseif dko#IsPlugged('vim-colors-solarized')
    let g:gruvbox_contrast_dark      = 'hard'
    let g:gruvbox_contrast_light     = 'hard'
    let g:gruvbox_italic             = 1
    let g:gruvbox_italicize_comments = 1
    let g:gruvbox_invert_selection   = 0
    if &t_Co != 256
      let g:gruvbox_termcolors = 16
    endif
    silent! colorscheme gruvbox
    set background=dark
    finish

  else
    silent! colorscheme delek
    set background=dark

  endif

catch /^Vim\%((\a\+)\)\=:E/
    silent! colorscheme delek

endtry

" after/plugin/colorscheme.vim

" ============================================================================
" gui
" ============================================================================

let s:use_solarized = 1
      \ && has('gui_running')
      \ && exists("g:plugs['vim-colors-solarized']")

if s:use_solarized
  let g:solarized_italic  = 0
  let g:solarized_menu    = 0
  silent! colorscheme solarized
  set background=light
  finish
endif

" ============================================================================
" terminal / fallbacks
" ============================================================================

if exists('g:plugs["gruvbox"]')
  let g:gruvbox_contrast_dark      = 'hard'
  let g:gruvbox_contrast_light     = 'hard'
  let g:gruvbox_italic             = 1
  let g:gruvbox_italicize_comments = 0
  let g:gruvbox_invert_selection   = 0
  if &t_Co != 256
    let g:gruvbox_termcolors = 16
  endif
  silent! colorscheme gruvbox
else
  silent! colorscheme delek
endif

set background=dark


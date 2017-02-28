" plugin/colorscheme.vim

if !has('nvim') && has('termguicolors')
  set termguicolors
endif

let s:colorscheme = 'default'
if dko#IsPlugged('Base2Tone-vim')
      \ && (has('nvim') || has('gui_running') || has('termguicolors'))
  let g:base16colorspace=256
  silent! colorscheme Base2Tone_LakeDark
  "set background=dark  " don't do this! colorscheme will source again
  finish
endif

if dko#IsPlugged('gruvbox')
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

else
  silent! colorscheme darkblue

endif

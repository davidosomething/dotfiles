" plugin/colorscheme.vim

if !has('nvim') && has('termguicolors')
  set termguicolors
endif

let s:colorscheme = 'default'
if (dko#IsPlugged('Base2Tone-vim') || dko#IsPlugged('vim-base2tone-lakedark'))
      \ && (has('nvim') || has('gui_running') || has('termguicolors'))
      \ && $TERM_PROGRAM !=# 'Apple_Terminal'
  let g:base16colorspace=256
  silent! colorscheme Base2Tone_LakeDark
  "set background=dark  " don't do this! colorscheme will source again
  finish
endif

if dko#IsPlugged('zazen')
  silent! colorscheme zazen
  if &t_Co == 256
    hi CursorLine ctermbg=236
  endif

else
  silent! colorscheme darkblue

endif

" plugin/colorscheme.vim

if !has('nvim') && has('termguicolors')
  set termguicolors
endif

let s:colorscheme = 'default'

if dko#IsPlugged('nord-vim')
  let g:nord_italic_comments = 1
endif

if (dko#IsPlugged('Base2Tone-vim') || dko#IsPlugged('vim-base2tone-lakedark'))
      \ && (has('nvim') || has('gui_running') || has('termguicolors'))
      \ && $TERM_PROGRAM !=# 'Apple_Terminal'
  let g:base16colorspace=256
  silent! colorscheme Base2Tone_LakeDark
  finish
endif

if dko#IsPlugged('two-firewatch')
  set background=dark
  silent! colorscheme two-firewatch
  finish

else
  silent! colorscheme darkblue
  finish

endif

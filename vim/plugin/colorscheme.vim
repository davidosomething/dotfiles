" plugin/colorscheme.vim

if !has('nvim') && has('termguicolors')
  set termguicolors
endif

let s:colorscheme = 'default'

if (dko#IsPlugged('Base2Tone-vim') || dko#IsPlugged('vim-base2tone-lakedark'))
      \ && (has('nvim') || has('gui_running') || has('termguicolors'))
      \ && $TERM_PROGRAM !=# 'Apple_Terminal'
  let g:base16colorspace=256
  let g:dko_colorscheme = 'Base2Tone_LakeDark'

  function! s:LakeDark() abort
    silent! colorscheme Base2Tone_LakeDark
  endfunction
  nnoremap <silent><special> <Leader>zb :<C-U>call <SID>LakeDark()<CR>
endif

if dko#IsPlugged('nord-vim')
  let g:nord_italic_comments = 1
  let g:dko_colorscheme = get(g:, 'dko_colorscheme', 'nord')
endif

if dko#IsPlugged('vim-two-firewatch')
  let g:dko_colorscheme = get(g:, 'dko_colorscheme', 'two-firewatch')

  function! s:Firewatch() abort
    set background=dark
    silent! colorscheme two-firewatch
  endfunction
  nnoremap <silent><special> <Leader>zt :<C-U>call <SID>Firewatch()<CR>

else
  let g:dko_colorscheme = get(g:, 'dko_colorscheme', 'darkblue')

endif

silent! execute 'colorscheme ' . g:dko_colorscheme

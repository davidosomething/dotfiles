" plugin/colorscheme.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

if exists('+termguicolors')
  let &termguicolors = has('termguicolors')
endif

let s:colorscheme = 'default'

if dkoplug#plugins#Exists('vim-base2tone-lakedark')
      \ && (has('nvim') || has('gui_running') || has('termguicolors'))
      \ && $TERM_PROGRAM !=# 'Apple_Terminal'
  let g:base16colorspace=256
  let g:dko_colorscheme = 'Base2Tone_LakeDark'

  function! s:LakeDark() abort
    set background=light
    silent! colorscheme Base2Tone_LakeDark
  endfunction
  nnoremap <silent><special> <Leader>zb :<C-U>call <SID>LakeDark()<CR>
endif

if dkoplug#plugins#Exists('nord-vim')
  let g:nord_italic_comments = 1
  let g:dko_colorscheme = get(g:, 'dko_colorscheme', 'nord')
endif

if dkoplug#plugins#Exists('vim-two-firewatch')
  let g:dko_colorscheme = 
        \ $ITERM_PROFILE =~? 'light'
        \   ? 'two-firewatch'
        \   : get(g:, 'dko_colorscheme', 'two-firewatch')

  function! s:Firewatch() abort
    set background=light
    silent! colorscheme two-firewatch
  endfunction
  nnoremap <silent><special> <Leader>zt :<C-U>call <SID>Firewatch()<CR>

else
  let g:dko_colorscheme = get(g:, 'dko_colorscheme', 'darkblue')

endif

silent! execute 'colorscheme ' . g:dko_colorscheme

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

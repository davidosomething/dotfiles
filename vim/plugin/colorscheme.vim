" plugin/colorscheme.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

let s:truecolor = exists('+termguicolors')
      \ && $TERM_PROGRAM !=# 'Apple_Terminal'
if s:truecolor | let &termguicolors = 1 | endif

let s:colorscheme = 'darkblue'

if dkoplug#plugins#Exists('vim-base2tone-lakedark')
  let g:base16colorspace = 256
  function! s:LakeDark() abort
    set background=dark
    silent! colorscheme Base2Tone_LakeDark
  endfunction
  nnoremap <silent><special> <Leader>zb :<C-U>call <SID>LakeDark()<CR>

  let s:colorscheme = 'Base2Tone_LakeDark'
endif

if dkoplug#plugins#Exists('nord-vim')
  let g:nord_italic_comments = 1
endif

if dkoplug#plugins#Exists('vim-two-firewatch')
  function! s:Firewatch() abort
    set background=light
    silent! colorscheme two-firewatch
  endfunction
  nnoremap <silent><special> <Leader>zt :<C-U>call <SID>Firewatch()<CR>

  let s:colorscheme = s:truecolor && $ITERM_PROFILE =~? 'light'
        \ ? 'two-firewatch'
        \ : s:colorscheme
endif

let s:colorscheme = s:truecolor || $TERM_PROGRAM =~? 'Hyper'
      \ ? 'dko'
      \ : s:colorscheme
nnoremap <silent><special> <Leader>zd :<C-U>silent! colorscheme dko<CR>

silent! execute 'colorscheme ' . s:colorscheme
"colorscheme dko

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

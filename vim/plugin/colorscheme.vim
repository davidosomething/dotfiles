" plugin/colorscheme.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

augroup dkocolorscheme
  autocmd!
augroup END

" ============================================================================

let s:truecolor = has('termguicolors') && $TERM_PROGRAM !=# 'Apple_Terminal'
if s:truecolor | let &termguicolors = 1 | endif

let s:colorscheme = 'darkblue'

if dkoplug#Exists('nord-vim')
  let g:nord_italic_comments = 1
endif

if dkoplug#Exists('vim-two-firewatch')
  function! s:Firewatch() abort
    silent! colorscheme two-firewatch
  endfunction
  nnoremap <silent><special> <Leader>zt :<C-U>call <SID>Firewatch()<CR>:set bg=light<CR>

  let s:colorscheme = s:truecolor && $ITERM_PROFILE =~? 'light'
        \ ? 'two-firewatch'
        \ : s:colorscheme
endif

let s:colorscheme = s:truecolor || $TERM_PROGRAM =~? 'Hyper'
      \ ? 'meh'
      \ : s:colorscheme
nnoremap <silent><special> <Leader>zd :<C-U>silent! colorscheme meh<CR>

autocmd dkocolorscheme
      \ VimEnter * nested
      \ silent! execute 'colorscheme ' . s:colorscheme

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

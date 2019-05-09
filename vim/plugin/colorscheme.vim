" plugin/colorscheme.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

augroup dkocolorscheme
  autocmd!
augroup END

" ============================================================================

let s:colorscheme = 'darkblue'

let s:truecolor = has('termguicolors')
      \ && $COLORTERM ==# 'truecolor'
      \ && $TERM_PROGRAM !=# 'Apple_Terminal'
if s:truecolor | let &termguicolors = 1 | endif

if s:truecolor
  let s:colorscheme = 'meh'

  if dkoplug#Exists('vim-two-firewatch')
    function! s:Firewatch() abort
      silent! colorscheme two-firewatch
    endfunction
    nnoremap <silent><special> <Leader>zt
          \ :<C-U>call <SID>Firewatch()<CR>:set bg=light<CR>

    let s:colorscheme = $ITERM_PROFILE =~? 'light'
          \ ? 'two-firewatch'
          \ : s:colorscheme
  endif
endif

autocmd dkocolorscheme
      \ VimEnter * nested
      \ silent! execute 'colorscheme ' . s:colorscheme

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

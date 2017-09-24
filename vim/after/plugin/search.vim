" after/plugin/search.vim
"
" This is an after/plugin since some plugins (in testing, like vim-searchant)
" might set their own mappings.
"
if exists('g:loaded_dko_search') | finish | endif
let g:loaded_dko_search = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

augroup dkosearch
  autocmd!
augroup END

" ============================================================================
" Clear search
" ============================================================================

silent! nunmap    <Esc><Esc>
nmap  <special>   <Plug>(DKOClearSearch)  :<C-U>nohlsearch<CR><C-l>

" Default, may be overridden by a plugin conf below
nmap  <special>   <Esc><Esc>   <Plug>(DKOClearSearch)

" ============================================================================

" - incsearch.vim   highlighting all matches
" - vim-anzu        show number of matches, with status integration
" - vim-asterisk    don't move on first search with *
" - vim-searchant   highlight CURRENT search item differently
if         !dko#IsLoaded('incsearch.vim')
      \ && !dko#IsLoaded('vim-asterisk')
      \ && !dko#IsLoaded('vim-anzu')
  finish
endif

" In case some other plugin tries something fishy
silent! unmap /
silent! unmap g/
silent! unmap ?
silent! unmap *
silent! unmap g*
silent! unmap #
silent! unmap g#
silent! unmap n
silent! unmap N

let g:asterisk#keeppos = 1

" Incsearch + Anzu interaction
if dko#IsLoaded('incsearch.vim') && dko#IsLoaded('vim-anzu')
  " Make sure / and g/ (which start an <over>-mode/fake-command mode) update
  " the anzu status
  autocmd dkosearch User IncSearchLeave AnzuUpdateSearchStatus
endif

function! s:SetupIncsearch() abort
  if !dko#IsLoaded('incsearch.vim') | return | endif

  map  /  <Plug>(incsearch-forward)
  map  g/ <Plug>(incsearch-stay)

  map  ?  <Plug>(incsearch-backward)

  if !dko#IsLoaded('vim-anzu')
    map  n  <Plug>(incsearch-nohl-n)
    map  N  <Plug>(incsearch-nohl-N)
  endif
endfunction
call s:SetupIncsearch()

function! s:SetupAnzu() abort
  if !dko#IsLoaded('vim-anzu') | return | endif

  " Replace anzu's cursormoved with my own that updates the tabline where
  " search status is displayed
  autocmd! anzu CursorMoved
  autocmd! anzu TextChanged
  autocmd! anzu TextChangedI
  autocmd dkosearch CursorMoved,Textchanged,TextChangedI *
        \   AnzuUpdateSearchStatus
        \ | call dkoline#RefreshTabline()

  " These will allow anzu to trigger on motions like `gd` but will cause
  " the status to re-enable even after <Esc><Esc>
  " Disable them. To enable anzu for other motions, should recursive map them
  " to trigger anzu#mode#start.
  let g:anzu_enable_CursorMoved_AnzuUpdateSearchStatus = 0
  let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 0

  " Mappings
  if dko#IsLoaded('incsearch.vim')
    map  n   <Plug>(incsearch-nohl)<Plug>(anzu-n)<Plug>(dkotabline-refresh)
    map  N   <Plug>(incsearch-nohl)<Plug>(anzu-N)<Plug>(dkotabline-refresh)
  else
    map  n   <Plug>(anzu-n)<Plug>(dkotabline-refresh)
    map  N   <Plug>(anzu-N)<Plug>(dkotabline-refresh)
  endif

  " Clear anzu in status AND unhighlight last search
  nmap  <special>  <Esc><Esc>
        \ <Plug>(anzu-clear-search-status)<Plug>(DKOClearSearch)
endfunction
call s:SetupAnzu()

" Get vim-asterisk, vim-anzu, and incsearch.vim to play nicely
"
" @param  {String} op for asterisk, translated to anzu also
" @return {String} <expr>
function! s:GetSearchRHS(op) abort
  let l:ops = ''

  " Highlight matches?
  if dko#IsLoaded('incsearch.vim')
    " no CursorMoved event if using vim-asterisk
    let l:ops .= dko#IsLoaded('vim-asterisk')
          \ ? '<Plug>(incsearch-nohl0)'
          \ : '<Plug>(incsearch-nohl)'
  endif

  " Move or don't move?
  let l:ops .= dko#IsLoaded('vim-asterisk')
        \ ? '<Plug>(asterisk-' . a:op . ')'
        \ : ''

  " Show count of matches after asterisk-z-op
  " Or use anzu-op if no vim-asterisk
  if dko#IsLoaded('vim-anzu')
    let l:anzu_op = ''
    let l:anzu_op = a:op ==# 'z*' ? 'star' : l:anzu_op
    let l:anzu_op = a:op ==# 'z#' ? 'sharp' : l:anzu_op
    if dko#IsLoaded('vim-asterisk') || empty(l:anzu_op)
      let l:ops .= '<Plug>(anzu-update-search-status)<Plug>(dkotabline-refresh)'
    else
      " no anzu stuff for gz* and gz#
      let l:ops .= '<Plug>(anzu-' . l:anzu_op . ')<Plug>(dkotabline-refresh)'
    endif
  endif

  return l:ops
endfunction
" the "z" means stay on the first match instead of autojump to next
execute 'map <special> * ' . s:GetSearchRHS('z*')
execute 'map <special> # ' . s:GetSearchRHS('z#')
execute 'map <special> g* ' . s:GetSearchRHS('gz*')
execute 'map <special> g# ' . s:GetSearchRHS('gz#')

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

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
nmap  <special>   <Plug>DKOClearSearch  :<C-U>nohlsearch<CR><C-l>

" Default, may be overridden by a plugin conf below
nmap  <special>   <Esc><Esc>   <Plug>DKOClearSearch

" ============================================================================

" - incsearch.vim   highlighting all matches
" - vim-anzu        show number of matches, with status integration
" - vim-asterisk    don't move on first search with *
" - vim-searchant   highlight CURRENT search item differently
if         !dko#IsPlugged('incsearch.vim')
      \ && !dko#IsPlugged('vim-asterisk')
      \ && !dko#IsPlugged('vim-anzu')
  finish
endif

" Get vim-asterisk, vim-anzu, and incsearch.vim to play nicely
"
" @param  {String} op
" @return {String} <expr>
function! s:GetSearchRHS(op) abort
  let l:long_op = a:op ==# '*' ? 'star' : 'sharp'

  let l:ops = ''

  " Highlight matches?
  if dko#IsPlugged('incsearch.vim')
    " no CursorMoved event if using vim-asterisk
    let l:ops .= dko#IsPlugged('vim-asterisk')
          \ ? "<Plug>(incsearch-nohl0)"
          \ : "<Plug>(incsearch-nohl)"
  endif

  " Move or don't move?
  let l:ops .= dko#IsPlugged('vim-asterisk')
        \ ? "<Plug>(asterisk-z" . a:op . ')'
        \ : ''

  " Show count of matches after asterisk-z-op
  " Or use anzu-op if no vim-asterisk
  if dko#IsPlugged('vim-anzu')
    let l:ops .= dko#IsPlugged('vim-asterisk')
          \ ? "<Plug>(anzu-update-search-status)"
          \ : "<Plug>(anzu-" . l:long_op . ')'
  endif

  return l:ops
endfunction

function! s:SetupIncsearch() abort
  if !dko#IsPlugged('incsearch.vim')
    return
  endif

  map  /  <Plug>(incsearch-forward)
  map  g/ <Plug>(incsearch-stay)

  map  ?  <Plug>(incsearch-backward)
  map  n  <Plug>(incsearch-nohl-n)
  map  N  <Plug>(incsearch-nohl-N)
  map  #  <Plug>(incsearch-nohl-#)
endfunction

function! s:SetupAnzu() abort
  if !dko#IsPlugged('vim-anzu')
    return
  endif

  " These will allow anzu to trigger on motions like `gd` but will cause
  " the status to re-enable even after <Esc><Esc>
  " Disable them. To enable anzu for other motions, should recursive map them
  " to trigger anzu#mode#start.
  let g:anzu_enable_CursorMoved_AnzuUpdateSearchStatus  = 0
  let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus   = 0

  " Mappings
  nmap  n   <Plug>(anzu-n)
  nmap  N   <Plug>(anzu-N)
  nmap  #   <Plug>(anzu-sharp)

  " Clear anzu in status AND unhighlight last search
  nmap  <special>  <Esc><Esc>
        \ <Plug>(anzu-clear-search-status)<Plug>DKOClearSearch
endfunction

" In case some other plugin tries something fishy
silent! unmap /
silent! unmap g/
silent! unmap ?
silent! unmap #
silent! unmap *

let g:asterisk#keeppos = 1

" Incsearch + Anzu interaction
if dko#IsPlugged('incsearch.vim') && dko#IsPlugged('vim-anzu')
  " Make sure / and g/ (which start an <over>-mode/fake-command mode) update
  " the anzu status
  autocmd dkosearch User IncSearchLeave AnzuUpdateSearchStatus
endif

call s:SetupIncsearch()
call s:SetupAnzu()

execute 'map <special> * ' . s:GetSearchRHS('*')

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

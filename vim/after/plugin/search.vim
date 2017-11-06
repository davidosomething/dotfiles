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

let s:is_native_incsearch = has('patch-8.0.1238')
      \ && !dkoplug#plugins#IsLoaded('incsearch.vim')

" ============================================================================
" Clear search
" ============================================================================

nmap  <special>   <Plug>(DKOClearSearch)  :<C-U>nohlsearch<CR><C-l>

silent! nunmap    <Esc><Esc>
nmap  <special>   <Esc><Esc>   <Plug>(DKOClearSearch)

" ============================================================================
" Native incsearch
" ============================================================================

" Tab/S-Tab go to next match while still in cmdline
if s:is_native_incsearch
  cnoremap <special><expr> <Tab>    getcmdtype() =~ '[?/]'
        \ ? '<C-g>' : feedkeys('<Tab>', 'int')[1]
  cnoremap <special><expr> <S-Tab>  getcmdtype() =~ '[?/]'
        \ ? '<C-t>' : feedkeys('<S-Tab>', 'int')[1]
endif

" ============================================================================

" - incsearch.vim   highlighting all matches
" - vim-anzu        show number of matches, with status integration
" - vim-asterisk    don't move on first search with *
" - vim-searchant   highlight CURRENT search item differently
if         !dkoplug#plugins#IsLoaded('incsearch.vim')
      \ && !dkoplug#plugins#IsLoaded('vim-asterisk')
      \ && !dkoplug#plugins#IsLoaded('vim-anzu')
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
if dkoplug#plugins#IsLoaded('incsearch.vim') && dkoplug#plugins#IsLoaded('vim-anzu')
  " Make sure / and g/ (which start an <over>-mode/fake-command mode) update
  " the anzu status
  autocmd dkosearch User IncSearchLeave AnzuUpdateSearchStatus
endif

function! s:SetupIncsearch() abort
  if !dkoplug#plugins#IsLoaded('incsearch.vim') | return | endif

  map  /  <Plug>(incsearch-forward)
  map  g/ <Plug>(incsearch-stay)

  map  ?  <Plug>(incsearch-backward)

  if !dkoplug#plugins#IsLoaded('vim-anzu')
    map  n  <Plug>(incsearch-nohl-n)
    map  N  <Plug>(incsearch-nohl-N)
  endif
endfunction
call s:SetupIncsearch()

function! s:SetupAnzu() abort
  if !dkoplug#plugins#IsLoaded('vim-anzu') | return | endif

  " Replace anzu's cursormoved with my own that updates the tabline where
  " search status is displayed
  autocmd! anzu CursorMoved
  autocmd dkosearch CursorMoved *
        \   AnzuUpdateSearchStatus
        \ | call dkoline#RefreshTabline()

  " These will allow anzu to trigger on motions like `gd` but will cause
  " the status to re-enable even after <Esc><Esc>
  " Disable them. To enable anzu for other motions, should recursive map them
  " to trigger anzu#mode#start.
  let g:anzu_enable_CursorMoved_AnzuUpdateSearchStatus = 0
  let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 0

  " Mappings
  if dkoplug#plugins#IsLoaded('incsearch.vim')
    map  n   <Plug>(incsearch-nohl)<Plug>(anzu-n)
    map  N   <Plug>(incsearch-nohl)<Plug>(anzu-N)
  else
    map  n   <Plug>(anzu-n)
    map  N   <Plug>(anzu-N)
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
  if dkoplug#plugins#IsLoaded('incsearch.vim')
    " no CursorMoved event if using vim-asterisk
    let l:ops .= dkoplug#plugins#IsLoaded('vim-asterisk')
          \ ? '<Plug>(incsearch-nohl0)'
          \ : '<Plug>(incsearch-nohl)'
  endif

  " Move or don't move?
  let l:ops .= dkoplug#plugins#IsLoaded('vim-asterisk')
        \ ? '<Plug>(asterisk-' . a:op . ')'
        \ : ''

  " Show count of matches after asterisk-z-op
  " Or use anzu-op if no vim-asterisk
  if dkoplug#plugins#IsLoaded('vim-anzu')
    let l:anzu_op = ''
    let l:anzu_op = a:op ==# 'z*' ? 'star' : l:anzu_op
    let l:anzu_op = a:op ==# 'z#' ? 'sharp' : l:anzu_op
    if dkoplug#plugins#IsLoaded('vim-asterisk') || empty(l:anzu_op)
      let l:ops .= '<Plug>(anzu-update-search-status)'
    else
      " no anzu stuff for gz* and gz#
      let l:ops .= '<Plug>(anzu-' . l:anzu_op . ')'
    endif
  endif

  let l:ops .= '<Plug>(dkoline-refresh-tabline)'

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

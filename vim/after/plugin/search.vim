" after/plugin/search.vim
"
" This is an after/plugin since some plugins (in testing, like vim-searchant)
" might set their own mappings.
"
if exists('g:loaded_dko_search') | finish | endif
let g:loaded_dko_search = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" In case some other plugin tries something fishy

silent! unmap /
silent! unmap g/
silent! unmap ?
silent! unmap n
silent! unmap N
silent! unmap #
silent! unmap *

" ============================================================================

" - incsearch.vim   highlighting all matches
" - vim-anzu        show number of matches, with status integration
" - vim-asterisk    don't move on first search with *
" - vim-searchant   highlight CURRENT search item differently

if dko#IsPlugged('incsearch.vim')
  map  /  <Plug>(incsearch-forward)
  map  g/ <Plug>(incsearch-stay)

  map  ?  <Plug>(incsearch-backward)
  map  n  <Plug>(incsearch-nohl)
  map  N  <Plug>(incsearch-nohl)
  map  #  <Plug>(incsearch-nohl)
endif

if dko#IsPlugged('vim-asterisk')
  let g:asterisk#keeppos = 1
endif

if dko#IsPlugged('vim-anzu')
  " Support other search modes like `gd`
  let g:anzu_enable_CursorMoved_AnzuUpdateSearchStatus = 1
  map  n  <Plug>(anzu-n)
  map  N  <Plug>(anzu-N)
endif

if         dko#IsPlugged('incsearch.vim')
      \ || dko#IsPlugged('vim-asterisk')
      \ || dko#IsPlugged('vim-anzu')
  map   <expr>  *   dko#Search('*')
endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

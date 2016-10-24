" after/plugin/search.vim
"
" This is an after/plugin since some plugins (in testing, like vim-searchant)
" might set their own mappings.
"
" @TODO maybe unmap before mapping in case some other plugin tries something
" fishy

if exists('g:loaded_dko_search') | finish | endif
let g:loaded_dko_search = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

" - incsearch.vim   highlighting all matches
" - vim-anzu        show number of matches, with status integration
" - vim-asterisk    don't move on first search with *
" - vim-searchant   highlight CURRENT search item differently

if dko#IsPlugged('incsearch.vim')
  " Swapped stay and forward
  map  /  <Plug>(incsearch-stay)
  map  g/  <Plug>(incsearch-forward)

  map  ?  <Plug>(incsearch-backward)
  map  n  <Plug>(incsearch-nohl)
  map  N  <Plug>(incsearch-nohl)
  map  #  <Plug>(incsearch-nohl)
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

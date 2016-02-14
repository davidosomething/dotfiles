" plugin/search.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

" - vim-anzu        show number of matches, with airline integration
" - vim-asterisk    don't move on first search with *
" - incsearch.vim   highlighting all matches

" Star search (*) mapping expression
" Get vim-asterisk, vim-anzu, and incsearch.vim to play nicely
function! s:DKO_StarSearch()
  let l:ops = ''

  " Move or don't move?
  if exists("g:plugs['vim-asterisk']")
    let l:ops = l:ops . "\<Plug>(asterisk-z*)"
  endif

  " Highlight matches?
  if exists("g:plugs['incsearch.vim']")
    " no CursorMoved event if using vim-asterisk
    if exists("g:plugs['vim-asterisk']")
      let l:ops = l:ops . "\<Plug>(incsearch-nohl0)"
    else
      let l:ops = l:ops . "\<Plug>(incsearch-nohl)"
    endif
  endif

  " Show count of matches
  if exists("g:plugs['vim-anzu']")
    if exists("g:plugs['vim-asterisk']")
      let l:ops = l:ops . "\<Plug>(anzu-update-search-status)"
    else
      let l:ops = l:ops . "\<Plug>(anzu-star)"
    endif
  endif

  return l:ops
endfunction

if !empty(s:DKO_StarSearch())
  nmap <special><expr>  *   <SID>DKO_StarSearch()
endif

if exists("g:plugs['incsearch.vim']")
  nmap  <special> /   <Plug>(incsearch-forward)
  nmap  <special> ?   <Plug>(incsearch-backward)
  nmap  <special> g/  <Plug>(incsearch-stay)
  nmap  <special> n   <Plug>(incsearch-nohl)
  nmap  <special> N   <Plug>(incsearch-nohl)
  nmap  <special> #   <Plug>(incsearch-nohl)
endif

if exists("g:plugs['vim-anzu']")
  " Support other search modes like `gd`
  let g:anzu_enable_CursorMoved_AnzuUpdateSearchStatus = 1
  nmap <special> n <Plug>(anzu-n)
  nmap <special> N <Plug>(anzu-N)
  nmap <special> # <Plug>(anzu-sharp)
endif

let &cpoptions = s:cpo_save
unlet s:cpo_save

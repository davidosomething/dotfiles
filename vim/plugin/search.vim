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
      let l:ops = l:ops . "\<Plug>(anzu-update-search-status-with-echo)"
    else
      let l:ops = l:ops . "\<Plug>(anzu-star-with-echo)"
    endif
  endif

  return l:ops
endfunction

if !empty(s:DKO_StarSearch())
  map <expr> * <SID>DKO_StarSearch()
endif

if exists("g:plugs['incsearch.vim']")
  map /   <Plug>(incsearch-forward)
  map ?   <Plug>(incsearch-backward)
  map g/  <Plug>(incsearch-stay)
endif

if exists("g:plugs['vim-anzu']")
  " Support other search modes like `gd`
  let g:anzu_enable_CursorMoved_AnzuUpdateSearchStatus = 1

  if exists("g:plugs['incsearch.vim']")
    nmap n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
    nmap N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)
    nmap # <Plug>(incsearch-nohl)<Plug>(anzu-sharp-with-echo)
  else
    nmap n <Plug>(anzu-n-with-echo)
    nmap N <Plug>(anzu-N-with-echo)
    nmap # <Plug>(anzu-sharp-with-echo)
  endif
endif


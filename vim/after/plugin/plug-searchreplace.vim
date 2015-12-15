" ============================================================================
" plug-searchreplace.vim
" ============================================================================
"
" These are various search and replace plugin settings
"
" Included are:
" - incsearch.vim for highlighting all matches
" - vim-anzu for showing number of matches with airline integration
" - vim-over for a new search/replace command mode

if exists("g:plugs['incsearch.vim']") && exists("*incsearch#go")
  map /   <Plug>(incsearch-forward)
  map ?   <Plug>(incsearch-backward)
  map g/  <Plug>(incsearch-stay)
endif

if exists('g:plugs["vim-anzu"]') && exists("*anzu#jump")
  if exists('g:plugs["incsearch.vim"]')
    nmap n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
    nmap N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)
    nmap * <Plug>(incsearch-nohl)<Plug>(anzu-star-with-echo)
    nmap # <Plug>(incsearch-nohl)<Plug>(anzu-sharp-with-echo)
  else
    nmap n <Plug>(anzu-n-with-echo)
    nmap N <Plug>(anzu-N-with-echo)
    nmap * <Plug>(anzu-star-with-echo)
    nmap # <Plug>(anzu-sharp-with-echo)
  endif

  " clear status
  nmap <Esc><Esc> <Plug>(anzu-clear-search-status)

  " show anzu
  if exists('g:plugs["vim-airline"]')
    let g:airline#extensions#anzu#enabled = 1
  endif
endif


if exists("g:plugs['vim-over']")
  let g:over_command_line_prompt = "over> "
  nnoremap <silent> <F7>   :OverCommandLine<CR>
  vnoremap <silent> <F7>   <Esc>:OverCommandLine<CR>
endif


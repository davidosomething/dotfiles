if !exists('g:plugs["vim-anzu"]') | finish | endif

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

augroup dkovimenhancedresolver
  autocmd!
  autocmd FileType javascript
        \ nmap <buffer> gf <Plug>(enhanced-resolver-go-cursor)
  autocmd FileType *
        \ nmap <buffer> gr <Plug>(enhanced-resolver-get-cursor)
augroup END

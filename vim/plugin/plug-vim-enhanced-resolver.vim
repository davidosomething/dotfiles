" plugin/plug-vim-enhanced-resolver.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

augroup dkovimenhancedresolver
  autocmd!
  autocmd FileType javascript
        \ nmap <buffer> gf <Plug>(enhanced-resolver-go-cursor)
  autocmd FileType *
        \ nmap <buffer> gr <Plug>(enhanced-resolver-echo-cursor)
  autocmd FileType *
        \ nmap <buffer> gR <Plug>(enhanced-resolver-echo-resolve)
augroup END

let &cpoptions = s:cpo_save
unlet s:cpo_save

let s:cpo_save = &cpoptions
set cpoptions&vim

if !executable('enhancedresolve') | finish | endif

nmap <silent><special>
      \ <Plug>(enhanced-resolver-go-cursor)
      \ :call enhancedresolver#GoCursor()<CR>

nmap <special>
      \ <Plug>(enhanced-resolver-get-cursor)
      \ :call enhancedresolver#GetCursorWord()<CR>

nmap <special>
      \ <Plug>(enhanced-resolver-echo-cursor)
      \ :echomsg enhancedresolver#ResolveCursor()<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save

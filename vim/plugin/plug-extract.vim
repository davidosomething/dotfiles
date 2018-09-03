" plugin/plug-extract.vim

if !dkoplug#IsLoaded('Extract') | finish | endif

let g:extract_maxCount = 20
let g:extract_useDefaultMappings = 0
let g:extract_loadNCM = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

nmap <silent> p <Plug>(extract-put)
nmap <silent> P <Plug>(extract-Put)
nmap <silent><special> <c-s> <Plug>(extract-sycle)
nmap <silent><special> <c-S> <Plug>(extract-Sycle)

function! s:Unmap() abort
  nmap <buffer> p <NOP>
  nmap <buffer> P <NOP>
  nmap <buffer><special> <c-s> <NOP>
  nmap <buffer><special> <c-S> <NOP>
endfunction
augroup dkoextract
  autocmd BufEnter * if !dko#IsEditable('%') | call s:Unmap() | endif
augroup END

let &cpoptions = s:cpo_save
unlet s:cpo_save

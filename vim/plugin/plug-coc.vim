" plugin/plug-coc.vim

if !dkoplug#IsLoaded('coc.nvim') | finish | endif

let g:coc_enable_locationlist = 0
let g:coc_snippet_next = '<C-f>'
let g:coc_snippet_prev = '<C-b>'

function! s:ShowDocumentation()
  if &filetype ==# 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

let s:cpo_save = &cpoptions
set cpoptions&vim

nmap <silent> <Leader>d <Plug>(coc-diagnostic-info)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> gh <Plug>(coc-declaration)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> K :<C-U>call <SID>ShowDocumentation()<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save

" plugin/plug-coc.vim

if !dkoplug#IsLoaded('coc.nvim') | finish | endif

augroup dkococ
  autocmd!
augroup END

function! s:ShowDocumentation()
  if &filetype ==# 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

let s:cpo_save = &cpoptions
set cpoptions&vim

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> K :<C-U>call <SID>ShowDocumentation()<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save


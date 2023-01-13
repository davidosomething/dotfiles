" plugin/automkdir.vim
" Replaces duggiefresh/vim-easydir; supports reloading vim instance or plugin

function! s:AutoMkdir() abort
  let l:directory = expand('<afile>:p:h')
  if !isdirectory(l:directory)
    call mkdir(l:directory, 'p')
  endif
endfunction

augroup dkoautomkdir
  autocmd!
  autocmd BufWritePre,FileWritePre * call s:AutoMkdir()
augroup END

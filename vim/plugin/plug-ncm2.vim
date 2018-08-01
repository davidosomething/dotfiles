" plugin/plug-ncm2.vim

if !g:dko_use_completion || !dkoplug#Exists('ncm2')
  finish
endif

augroup dkoncm
  autocmd!
  autocmd BufEnter * call ncm2#enable_for_buffer()
augroup END

" Reduce priority below langclient's 9
let g:ncm2_tern#source = { 'priority': 8 }

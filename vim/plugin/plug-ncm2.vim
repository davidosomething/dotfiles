" plugin/plug-ncm2.vim

if !g:dko_use_completion || !dkoplug#Exists('ncm2')
  finish
endif

augroup dkoncm
  autocmd!
augroup END

" Reduce priority below langclient's 9
let g:ncm2_tern#source = { 'priority': 8 }

function s:DelayedStart(...)
  if &filetype ==# 'vim-plug' | return | endif
  call ncm2#enable_for_buffer()
endfunc
autocmd dkoncm BufEnter * call timer_start(60, function('s:DelayedStart'))

" plugin/plug-ncm2.vim

if !g:dko_use_completion || !dkoplug#Exists('ncm2')
  finish
endif

augroup dkoncm
  autocmd!
augroup END

" Reduce priority below langclient's 9
let g:ncm2_tern#source = { 'priority': 8 }

" Make sure ncm2-jedi is the only source for python
" https://github.com/ncm2/ncm2/issues/60#issuecomment-412261629
call ncm2#override_source('LanguageClient_python', { 'enable': 0 })

let s:ft_no_completion = [ 'vim-plug', 'git' ]
function s:DelayedStart(...)
  if index(s:ft_no_completion, &filetype) > -1 | return | endif
  call ncm2#enable_for_buffer()
endfunc
autocmd dkoncm BufEnter * call timer_start(60, function('s:DelayedStart'))

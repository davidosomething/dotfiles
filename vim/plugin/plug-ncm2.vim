" plugin/plug-ncm2.vim

if !g:dko_use_completion || !dkoplug#Exists('ncm2')
  finish
endif

augroup dkoncm
  autocmd!
augroup END

" short delay so I can type fast
let g:ncm2#complete_delay = 10

" Deault "abbrfuzzy" but I usually know what I'm completing
let g:ncm2#matcher = 'prefix'

" Deault "abbrfuzzy" but I'm not using that
let g:ncm2#sorter = 'alphanum'

" Reduce priority below langclient's 9
let g:ncm2_tern#source = { 'priority': 8 }

" Make sure ncm2-jedi is the only source for python
" https://github.com/ncm2/ncm2/issues/60#issuecomment-412261629
call ncm2#override_source('LanguageClient_python', { 'enable': 0 })

"Enable, disable tern based on buffer's .tern-project presence
" autocmd dkoncm BufEnter *.{js,json,jsx,tsx}
"       \ call ncm2#override_source('ncm2_tern', {
"       \   'enable': !empty(dko#project#javascript#GetTernProject())
"       \ })

" Delayed and filetype conditional start
let s:ft_no_completion = []
function s:DelayedStart(...)
  if dko#IsNonFile('%') || index(s:ft_no_completion, &filetype) != -1
    return
  endif
  call ncm2#enable_for_buffer()
endfunction
autocmd dkoncm BufEnter * call timer_start(60, function('s:DelayedStart'))

" autoload/dko/blackhole.vim

" Manual blackhole

let s:cpo_save = &cpoptions
set cpoptions&vim

function! s:Blackhole(key) abort
  execute 'nnoremap ' . a:key . ' "' . a:key . a:key
  execute 'xnoremap ' . a:key . ' "' . a:key . a:key
endfunction

let s:blackhole_keys = [ 'c', 'C', 'd', 'D', 's', 'S', 'x', 'X' ]
for s:key in s:blackhole_keys
  call s:Blackhole(s:key)
endfor

let s:register = has('clipboard') ? '"*' : '""'
execute 'nnoremap m ' . s:register . 'd'
execute 'nnoremap M ' . s:register . 'dd'
execute 'xnoremap m ' . s:register . 'd'
execute 'xnoremap M ' . s:register . 'dd'
execute 'nnoremap mm ' . s:register . 'dd'
execute 'xnoremap mm ' . s:register . 'dd'

let &cpoptions = s:cpo_save
unlet s:cpo_save

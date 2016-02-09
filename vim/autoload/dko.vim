function! dko#rtp() abort
  put! =split(&runtimepath, ',', 0)
endfunction

function! dko#InitObject(var) abort
  let {a:var} = exists(a:var) ? {a:var} : {}
endfunction

function! dko#BindFunction(key, command) abort
  let l:lhs = 'noremap <silent><special> ' . a:key . ' '
  let l:rhs = ':<C-u>' . a:command . '<CR>'
  execute 'n' . l:lhs .           l:rhs
  execute       l:lhs . '<Esc>' . l:rhs
endfunction


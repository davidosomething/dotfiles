" autoload/dko.vim

function! dko#rtp() abort
  put! =split(&runtimepath, ',', 0)
endfunction

function! dko#InitObject(var) abort
  let {a:var} = exists(a:var) ? {a:var} : {}
endfunction

" return string to execute (this way :verb map traces back to correct file)
function! dko#BindFunction(key, command) abort
  " <unique> will report errors if already mapped!
  let l:lhs = '<unique><silent><special> ' . a:key . ' '
  let l:rhs = ':<C-u>' . a:command . '<CR>'
  " mapmode-nvo
  return 'noremap '  . l:lhs .           l:rhs
  " mapmode-ic
  return 'noremap! ' . l:lhs . '<Esc>' . l:rhs
endfunction


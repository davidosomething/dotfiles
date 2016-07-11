" autoload/dko.vim

let dko#vim_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':p:h')

function! dko#rtp() abort
  put! =split(&runtimepath, ',', 0)
endfunction

function! dko#InitObject(var) abort
  let {a:var} = exists(a:var) ? {a:var} : {}
endfunction

" return string to execute (this way :verb map traces back to correct file)
function! dko#BindFunction(key, command) abort
  let l:lhs = '<silent><special> ' . a:key . ' '
  let l:rhs = ':<C-u>' . a:command . '<CR>'
  " mapmode-nvo
  return 'noremap '  . l:lhs .           l:rhs
  " mapmode-ic
  return 'noremap! ' . l:lhs . '<Esc>' . l:rhs
endfunction


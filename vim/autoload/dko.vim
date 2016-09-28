" autoload/dko.vim

let g:dko#vim_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':p:h')

" Output &runtimepath, one per line, to current buffer
function! dko#Runtimepath() abort
  put! =split(&runtimepath, ',', 0)
endfunction

" Assigns a new object to a variable if it doesn't exist yet
" @param string var
function! dko#InitObject(var) abort
  let {a:var} = exists(a:var) ? {a:var} : {}
endfunction

" @param string key
" @param string command
" @return string to execute (this way :verb map traces back to correct file)
function! dko#BindFunction(key, command) abort
  let l:lhs = '<silent><special> ' . a:key . ' '
  let l:rhs = ':<C-u>' . a:command . '<CR>'
  " mapmode-nvo
  return 'noremap '  . l:lhs .           l:rhs
  " mapmode-ic
  return 'noremap! ' . l:lhs . '<Esc>' . l:rhs
endfunction

" @param string name
" @return boolean
function! dko#IsPlugged(name) abort
  " Use exists instead of has_key so can skip checking if g:plugs itself
  " exists
  return exists("g:plugs['" . a:name . "']")
        \ && isdirectory(expand(g:plug_home . '/' . a:name))
endfunction

" autoload/dko.vim
"
" vimrc and debugging helper funtions
"

let g:dko#vim_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':p:h')

" Output &runtimepath, one per line, to current buffer
function! dko#Runtimepath() abort
  put! =split(&runtimepath, ',', 0)
endfunction

" Declare and define var as new dict if the variable has not been used before
"
" @param string var
" @return the declared var
function! dko#InitDict(var) abort
  let {a:var} = exists(a:var) ? {a:var} : {}
  return {a:var}
endfunction

" Declare and define var as new list if the variable has not been used before
"
" @param string var
" @return the declared var
function! dko#InitList(var) abort
  let {a:var} = exists(a:var) ? {a:var} : []
  return {a:var}
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

" ============================================================================
" vim-plug helpers
" ============================================================================

" Memory cache
let s:plugged = {}

" @param string name
" @return boolean true if the plugin is installed
function! dko#IsPlugged(name) abort
  if has_key(s:plugged, a:name)
    return s:plugged[a:name]
  endif

  " Use exists instead of has_key so can skip checking if g:plugs itself
  " exists
  let l:is_plugged = exists("g:plugs['" . a:name . "']")
        \ && isdirectory(expand(g:plug_home . '/' . a:name))

  let s:plugged[a:name] = l:is_plugged

  return l:is_plugged
endfunction

" ============================================================================
" Neomake helpers
" ============================================================================

" @param string name of maker
" @param string [a:1] ft of the maker, defaults to current buffers filetype
" @return boolean true when the maker exe exists or was registered as a local
"
"         maker (so local exe exists)
function! dko#IsMakerExecutable(name, ...) abort
  if !exists('*neomake#GetMaker')
    return 0
  endif

  let l:ft = get(a:, 1, &filetype)
  if empty(l:ft)
    return 0
  endif

  let l:maker = neomake#GetMaker(a:name, l:ft)
  return !empty(l:maker) && executable(l:maker.exe)
endfunction


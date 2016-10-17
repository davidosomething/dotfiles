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
" @param  {String} var
" @return {String} the declared var name
function! dko#InitDict(var) abort
  let {a:var} = exists(a:var) ? {a:var} : {}
  return {a:var}
endfunction

" Declare and define var as new list if the variable has not been used before
"
" @param  {String} var
" @return {String} the declared var name
function! dko#InitList(var) abort
  let {a:var} = exists(a:var) ? {a:var} : []
  return {a:var}
endfunction

" @param  {String} key
" @param  {String} command
" @return {String} to execute (this way :verb map traces back to correct file)
function! dko#BindFunction(key, command) abort
  let l:lhs = '<silent><special> ' . a:key . ' '
  let l:rhs = ':<C-u>' . a:command . '<CR>'
  let l:mapping_nvo = 'noremap '  . l:lhs .           l:rhs
  let l:mapping_ic  = 'noremap! ' . l:lhs . '<Esc>' . l:rhs
  return l:mapping_nvo . ' | ' . l:mapping_ic
endfunction

" ============================================================================
" vim-plug helpers
" ============================================================================

" Memory cache
let s:plugged = {}

" @param  {String} name
" @return {Boolean} true if the plugin is installed
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

" @param  {String} name of maker
" @param  {String} [a:1] ft of the maker, defaults to current buffers filetype
" @return {Boolean} true when the maker exe exists or was registered as a local
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

" ============================================================================
" Code parsing
" ============================================================================

" @param {String} [1] cursor position to look, defaults to current cursorline
" @return {String}
function! dko#GetFunctionName() abort
  let l:position = get(a:, 1, getline('.')[:col('.')-2])

  let l:matches = matchlist(l:position, '\([a-zA-Z0-9_]*\)([^()]*$')
  if empty(l:matches)
    return ''
  endif

  return get(l:matches, 1, '')
endfunction

" Show function signature using various plugins
function! dko#GetFunctionSignature() abort
  let l:source = ''
  let l:function = ''

  if exists('g:loaded_cfi')
    let l:function = cfi#format('%s', '')
    if !empty(l:function)
      let l:source = 'cfi'
    endif
  endif

  " disabled, too many false positives
  if 0 && empty(l:function) && dko#IsPlugged('vim-gazetteer')
    try
      let l:function = gazetteer#WhereAmI()
    endtry
    if !empty(l:function)
      let l:source = 'gzt'
    endif
  endif

  return (g:dkotabline_show_function_signature_source
        \     ? '[' . l:source . ']'
        \     : '')
        \ . l:function
endfunction


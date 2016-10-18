" autoload/dko.vim
"
" vimrc and debugging helper funtions
"

" ============================================================================
" Guards
" ============================================================================

if exists('g:loaded_dko') | finish | endif
let g:loaded_dko = 1

" ============================================================================
" Setup vars
" ============================================================================

let g:dko#vim_dir = fnamemodify(resolve(expand('$MYVIMRC')), ':p:h')

" ============================================================================
" General VimL utility functions
" ============================================================================

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

" Generate a string command to map keys in nvo&ic modes to a command
"
" @param  {Dict}    settings
" @param  {String}  settings.key
" @param  {String}  [settings.command]
" @param  {Int}     [settings.special]
" @return {String}  to execute (this way :verb map traces back to correct file)
function! dko#MapAll(settings) abort
  " Auto determine if special key was mapped
  " Just in case I forgot to include cpoptions guards somewhere
  let l:special = get(a:settings, 'special', 0) || a:settings.key[0] ==# '<'
        \ ? '<special>'
        \ : ''

  " Key to map
  let l:lhs = '<silent>'
        \ . l:special
        \ . ' ' . a:settings.key . ' '

  " Command to map to
  if !empty(get(a:settings, 'command', ''))
    let l:rhs_nvo = ':<C-u>' . a:settings.command . '<CR>'
    let l:rhs_ic  = '<Esc>' . l:rhs_nvo
  else
    " No command
    " @TODO support non command mappings
    return ''
  endif

  " Compose result
  let l:mapping_nvo = 'noremap '  . l:lhs . ' ' . l:rhs_nvo
  let l:mapping_ic  = 'noremap! ' . l:lhs . ' ' . l:rhs_ic
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
function! dko#GetFunctionInfo() abort

  " --------------------------------------------------------------------------
  " By current-func-info.vim
  " --------------------------------------------------------------------------

  if exists('g:loaded_cfi')
    return {
          \   'name':   cfi#get_func_name(),
          \   'source': 'cfi',
          \ }
  endif

  " --------------------------------------------------------------------------
  " By VimL
  " --------------------------------------------------------------------------

  "let l:position = get(a:, 1, getline('.')[:col('.')-2])
  let l:position = getline('.')
  let l:matches = matchlist(l:position, '\(()\s[a-zA-Z0-9_]*\)([^()]*$')
  if empty(l:matches) || empty(l:matches[1])
    return {}
  endif
  return {
        \   'name':   l:matches[1],
        \   'source': 'viml',
        \ }

endfunction


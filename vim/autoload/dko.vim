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
let g:dko#plug_dir = '/vendor/'
let g:dko#plug_absdir = g:dko#vim_dir . g:dko#plug_dir

" ============================================================================
" General VimL utility functions
" ============================================================================

" @TODO
" @param {String} needle
" @param {String} haystack
" @return {number} 1 true
function! dko#StartsWith(needle, haystack) abort
  return match(a:haystack, '\V' . a:needle)
endfunction

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

" Convert to dictionary with keys as filenames
" This will basically uniq() without sorting
"
" @param {List} a
" @param {List} b
" @return {List}
function! dko#Uniq(a, b) abort
  let l:results = {}
  let l:combined = a:a + a:b
  for l:item in l:combined | let l:results[l:item] = 1 | endfor
  return keys(l:results)
endfunction

" Return shortened path
"
" @param {String} path
" @param {Int} max
" @return {String}
function! dko#ShortenPath(path, ...) abort
  let l:max = get(a:, 1, 0)
  let l:full = fnamemodify(a:path, ':~:.')
  return l:max && len(l:full) > l:max
        \ ? ''
        \ : ' ' . (len(l:full) == 0 ? '~' : l:full) . ' '
endfunction

" Generate a string command to map keys in nvo&ic modes to a command
"
" @param  {Dict}    settings
" @param  {String}  settings.key
" @param  {String}  [settings.command]
" @param  {Int}     [settings.special]
" @param  {Int}     [settings.remap]
" @return {String}  to execute (this way :verb map traces back to correct file)
function! dko#MapAll(settings) abort
  " Auto determine if special key was mapped
  " Just in case I forgot to include cpoptions guards somewhere
  let l:special = get(a:settings, 'special', 0) || a:settings.key[0] ==# '<'
        \ ? '<special>'
        \ : ''

  let l:remap = get(a:settings, 'remap', 1)
        \ ? 'nore'
        \ : ''

  " Key to map
  let l:lhs = '<silent>'
        \ . l:special
        \ . ' ' . a:settings.key . ' '

  " Command to map to
  if !empty(get(a:settings, 'command', ''))
    let l:rhs_nvo = ':<C-U>' . a:settings.command . '<CR>'
    let l:rhs_ic  = '<Esc>' . l:rhs_nvo
  else
    " No command
    " @TODO support non command mappings
    return ''
  endif

  " Compose result
  let l:mapping_nvo = l:remap . 'map '  . l:lhs . ' ' . l:rhs_nvo
  let l:mapping_ic  = l:remap . 'map! ' . l:lhs . ' ' . l:rhs_ic
  return l:mapping_nvo . '| ' . l:mapping_ic
endfunction

" @param {List} list
" @return {List} deduplicated list
function! dko#Unique(list) abort
  " stackoverflow style -- immutable, but unnecessary since we're operating on
  " a copy of the list in a:list anyway
  "return filter( copy(l:list), 'index(l:list, v:val, v:key + 1) == -1' )

  " xolox style -- mutable list
  return reverse(filter(reverse(a:list), 'count(a:list, v:val) == 1'))
endfunction

" @param {List} a:000 args
" @return {Mixed} first arg that is non-empty or empty string
function! dko#First(...) abort
  let l:list = type(a:1) == type([]) ? a:1 : a:000
  for l:item in l:list
    if !empty(l:item) | return l:item | endif
  endfor
  return ''
endfunction

function! dko#BorG(var, default) abort
  return get(b:, a:var, get(g:, a:var, a:default))
endfunction

" ============================================================================
" Buffer info
" ============================================================================

" @param {Int|String} bufnr or {expr} as in bufname()
" @return {Boolean}
function! dko#IsHelp(bufnr) abort
  return getbufvar(a:bufnr, '&buftype') ==# 'help'
endfunction

" @param {Int|String} bufnr or {expr} as in bufname()
" @return {Boolean}
function! dko#IsNonFile(bufnr) abort
  let l:ft = getbufvar(a:bufnr, '&filetype')
  return getbufvar(a:bufnr, '&buftype') =~# '\v(help|nofile|quickfix|terminal)'
        \ || l:ft ==# 'git'
        \ || l:ft =~# '\v(netrw|vim-plug)'
endfunction

" @param {Int|String} bufnr or {expr} as in bufname()
" @return {Boolean}
function! dko#IsEditable(bufnr) abort
  return !getbufvar(a:bufnr, '&readonly') && !dko#IsNonFile(a:bufnr)
endfunction

" ============================================================================
" Whitespace settings
" ============================================================================

function! dko#TwoSpace() abort
  setlocal expandtab shiftwidth=2 softtabstop=2
endfunction

function! dko#TwoTabs() abort
  setlocal noexpandtab shiftwidth=2 softtabstop=2
endfunction

function! dko#FourTabs() abort
  setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=0
endfunction

" ============================================================================
" grepprg
" ============================================================================

" Cached
function! dko#GetGrepper() abort
  if exists('s:grepper') | return s:grepper | endif

  let l:greppers = {}
  let l:greppers.rg = {
        \   'command': 'rg',
        \   'options': [
        \     '--hidden',
        \     '--smart-case',
        \     '--no-heading',
        \     '--vimgrep',
        \   ],
        \   'format': '%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m',
        \ }
  let l:greppers.ag = {
        \   'command': 'ag',
        \   'options': [
        \     '--hidden',
        \     '--smart-case',
        \     '--vimgrep',
        \   ],
        \   'format': '%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m',
        \ }
  let l:greppers.ack = {
        \   'command': 'ack',
        \   'options': [
        \     '--nogroup',
        \     '--nocolor',
        \     '--smart-case',
        \     '--column',
        \   ],
        \   'format': '%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m',
        \ }

  let l:grepper_name =
        \   executable('rg') ? 'rg'
        \ : executable('ag') ? 'ag'
        \ : executable('ack') ? 'ack'
        \ : ''

  let s:grepper = empty(l:grepper_name) ? {} : l:greppers[l:grepper_name]

  return s:grepper
endfunction

" ============================================================================
" Filepath helpers
" ============================================================================

" @param {String[]} pathlist to shorten and validate
" @param {String} base to prepend to paths
" @return {String[]} filtered pathlist
function! dko#ShortPaths(pathlist, ...) abort
  let l:pathlist = a:pathlist

  " Prepend base path
  if isdirectory(get(a:, 1, ''))
    call map(l:pathlist, "a:1 . '/' . v:val")
  endif

  " Filter out non-existing files (e.g. when given deleted filenames from
  " `git diff -name-only`)
  call filter(l:pathlist, 'filereadable(expand(v:val))')

  " Shorten
  return map(l:pathlist, "fnamemodify(v:val, ':~:.')" )
endfunction

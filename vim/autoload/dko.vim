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
let g:dko#plug_absdir = expand('$XDG_DATA_HOME') . '/vim' . g:dko#plug_dir

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
" Filepath helpers
" ============================================================================

" Hide CWD in a path (make relative to CWD)
"
" @param {String[]} pathlist to shorten and validate
" @param {String} base to prepend to paths
" @return {String[]} filtered pathlist
function! dko#ShortPaths(pathlist, ...) abort
  let l:pathlist = a:pathlist

  " Prepend base path
  if isdirectory(get(a:, 1, ''))
    call map(l:pathlist, "a:1 . '/' . v:val")
  endif

  " Shorten
  return map(l:pathlist, "fnamemodify(v:val, ':.')" )
endfunction

" Return shortened path
"
" @param {String} path
" @param {Int} max
" @return {String}
function! dko#HomePath(path, ...) abort
  let l:max = get(a:, 1, 0)
  let l:full = fnamemodify(a:path, ':~:.')
  return l:max && len(l:full) > l:max
        \ ? ''
        \ : (len(l:full) == 0 ? '~' : l:full)
endfunction

" ============================================================================
" Filetype
" ============================================================================

function! dko#IsShebangBash() abort
  return getline(1) =~# '^#!.*bash'
endfunction

" ============================================================================
" Buffer info
" ============================================================================

" @param {Int|String} bufnr or {expr} as in bufname()
" @return {Boolean}
function! dko#IsHelp(bufnr) abort
  return getbufvar(a:bufnr, '&buftype') ==# 'help'
endfunction

let s:nonfilebuftypes = join([
      \ 'help',
      \ 'nofile',
      \ 'quickfix',
      \ 'terminal',
      \], '|')

let s:nonfilefiletypes = join([
      \ 'git$',
      \ 'netrw',
      \ 'vim-plug'
      \], '|')

" @param {Int|String} bufnr or {expr} as in bufname()
" @return {Boolean}
function! dko#IsNonFile(bufnr) abort
  let l:ft = getbufvar(a:bufnr, '&filetype')
  let l:bt = getbufvar(a:bufnr, '&buftype')
  return l:bt =~# '\v(' . s:nonfilebuftypes . ')'
        \ || l:ft =~# '\v(' . s:nonfilefiletypes . ')'
endfunction

" @param {Int|String} bufnr or {expr} as in bufname()
" @return {Boolean}
function! dko#IsEditable(bufnr) abort
  return getbufvar(a:bufnr, '&modifiable')
        \ && !getbufvar(a:bufnr, '&readonly')
        \ && !dko#IsNonFile(a:bufnr)
endfunction

" Usually to see if there's a linter/syntax
"
" @param {Int|String} bufnr
" @return {Boolean}
function! dko#IsTypedFile(...) abort
  let l:bufnr = get(a:, 1, '%')
  return !empty(getbufvar(l:bufnr, '&filetype')) && !dko#IsNonFile(l:bufnr)
endfunction

" ============================================================================
" Restore Position
" From vim help docs on last-position-jump
" ============================================================================

" http://stackoverflow.com/questions/6496778/vim-run-autocmd-on-all-filetypes-except
let s:excluded_ft = [
      \   'gitbranchdescription',
      \   'gitcommit',
      \   'gitrebase',
      \   'hgcommit',
      \   'svn',
      \ ]
function! dko#RestorePosition() abort
  if !dko#IsNonFile('%') || (
        \   index(s:excluded_ft, &filetype) < 0
        \   && line("'\"") > 1 && line("'\"") <= line('$')
        \)

    " Last check for file exists
    " https://github.com/farmergreg/vim-lastplace/blob/48ba343c8c1ca3039224727096aae214f51327d1/plugin/vim-lastplace.vim#L38
    try
      if empty(glob(@%)) | return | endif
    catch | return
    endtry
    silent! normal! g`"
  endif
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

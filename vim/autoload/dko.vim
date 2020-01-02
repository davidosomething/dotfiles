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
" Factories
" ============================================================================

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
" Floating windows
" ============================================================================

let s:DEFAULT_MODAL_HEIGHT_RATIO = 0.8
let s:DEFAULT_MODAL_WIDTH_RATIO = 0.8
function! dko#GetModalOptions(params) abort
  let l:opts = {}
  let l:opts.relative = 'editor'
  let l:opts.style = 'minimal'

  " size
  let l:ratio_height = float2nr(&lines * s:DEFAULT_MODAL_HEIGHT_RATIO)
  let l:max_height = &lines - 20
  let l:opts.height = max([
        \   l:ratio_height,
        \   l:max_height,
        \   1,
        \ ])
  let l:ratio_width = float2nr(&columns * s:DEFAULT_MODAL_WIDTH_RATIO)
  let l:max_width = &columns - 20
  let l:opts.width = max([
        \   l:ratio_width,
        \   l:max_width,
        \   1,
        \ ])

  " centered
  let l:opts.row = float2nr((&lines - l:opts.height) / 2)
  let l:opts.col = float2nr((&columns - l:opts.width) / 2)

  return extend(l:opts, a:params)
endfunction

" Adapted from https://github.com/junegunn/fzf.vim/issues/664
function! dko#Modal(hl, params) abort
  let l:buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')
  let l:opts = dko#GetModalOptions(a:params)
  let l:win = nvim_open_win(l:buf, v:true, l:opts)
  call setwinvar(l:win, '&winhighlight', 'NormalFloat:' . a:hl)
  call setwinvar(l:win, '&colorcolumn', '')
  return { 'buf': l:buf, 'win': l:win }
endfunction

function! dko#BorderedModal() abort
  let l:opts = dko#GetModalOptions({})
  let l:top = '╭' . repeat('─', l:opts.width - 2) . '╮'
  let l:mid = '│' . repeat(' ', l:opts.width - 2) . '│'
  let l:bot = '╰' . repeat('─', l:opts.width - 2) . '╯'
  let l:border = [l:top] + repeat([l:mid], l:opts.height - 2) + [l:bot]

  " Draw frame
  let s:modal = dko#Modal('Ignore', {
        \   'row': l:opts.row,
        \   'col': l:opts.col,
        \   'width': l:opts.width,
        \   'height': l:opts.height
        \ })
  call nvim_buf_set_lines(s:modal.buf, 0, -1, v:true, l:border)

  " Draw viewport
  call dko#Modal('Normal', {
        \   'row': l:opts.row + 1,
        \   'col': l:opts.col + 2,
        \   'width': l:opts.width - 4,
        \   'height': l:opts.height - 2
        \ })
  autocmd BufWipeout <buffer> execute 'bwipeout' s:modal.buf
endfunction

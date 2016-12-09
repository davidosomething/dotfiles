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
  for l:item in a:000
    if !empty(l:item) | return l:item | endif
  endfor
  return ''
endfunction

" ============================================================================
" grepprg
" ============================================================================

function! dko#GetGrepper() abort
  if exists('s:grepper') | return s:grepper | endif

  let s:greppers = {}
  let s:greppers.rg = {
        \   'command': 'rg',
        \   'options': [
        \     '--hidden',
        \     '--smart-case',
        \     '--no-heading',
        \     '--vimgrep',
        \   ],
        \   'format': '%f:%l:%c:%m',
        \ }
  let s:greppers.ag = {
        \   'command': 'ag',
        \   'options': [
        \     '--hidden',
        \     '--smart-case',
        \     '--vimgrep',
        \   ],
        \   'format': '%f:%l:%c:%m,%f:%l:%m',
        \ }
  let s:greppers.ack = {
        \   'command': 'ack',
        \   'options': [
        \     '--nogroup',
        \     '--nocolor',
        \     '--smart-case',
        \     '--column',
        \   ],
        \   'format': '%f:%l:%c:%m,%f:%l:%m',
        \ }

  let s:grepper_name =
        \   executable('ag') ? 'ag'
        \ : executable('rg') ? 'rg'
        \ : executable('ack') ? 'ack'
        \ : ''

  let s:grepper = empty(s:grepper_name) ? {} : s:greppers[s:grepper_name]

  return s:grepper
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
        \ && ( isdirectory(expand(g:plug_home . '/' . a:name))
        \      || isdirectory(expand(g:dko#vim_dir . '/mine/' . a:name)) )

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

" ============================================================================
" Vim introspection
" ============================================================================

let s:mru_blacklist = "v:val !~ '" . join([
      \   'fugitive:',
      \   'NERD_tree',
      \   '^/tmp/',
      \   '.git/',
      \   '\[.*\]',
      \   'vim/runtime/doc',
      \ ], '\|') . "'"

" @return {List} recently used and still-existing files
function! dko#GetMru() abort
  " Shortened(Readable(Whitelist)
  return dko#ShortPaths(filter(copy(v:oldfiles), s:mru_blacklist))
endfunction

" @return {List} listed buffers
function! dko#GetBuffers() abort
  return map(
        \   filter(range(1, bufnr('$')), 'buflisted(v:val)'),
        \   'bufname(v:val)'
        \ )
endfunction

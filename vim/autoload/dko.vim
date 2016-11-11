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
        \   executable('rg') ? 'rg'
        \ : executable('ag') ? 'ag'
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
" Search helpers
" ============================================================================

" Get vim-asterisk, vim-anzu, and incsearch.vim to play nicely
"
" @param  {String} op
" @return {String} <expr>
function! dko#Search(op) abort
  let l:long_op = a:op ==# '*' ? 'star' : 'sharp'

  let l:ops = ''

  " Highlight matches?
  if dko#IsPlugged('incsearch.vim')
    " no CursorMoved event if using vim-asterisk
    let l:ops .= dko#IsPlugged('vim-asterisk')
          \ ? "\<Plug>(incsearch-nohl0)"
          \ : "\<Plug>(incsearch-nohl)"
  endif

  " Move or don't move?
  let l:ops .= dko#IsPlugged('vim-asterisk')
        \ ? "\<Plug>(asterisk-z" . a:op . ')'
        \ : ''

  " Show count of matches
  if dko#IsPlugged('vim-anzu')
    let l:ops .= dko#IsPlugged('vim-asterisk')
          \ ? "\<Plug>(anzu-update-search-status)"
          \ : "\<Plug>(anzu-" . l:long_op . ')'
  endif

  return l:ops
endfunction

" ============================================================================
" Vim introspection
" ============================================================================

let s:mru_blacklist = "v:val !~ '" . join([
      \   'fugitive:',
      \   'NERD_tree',
      \   '^/tmp/',
      \   '.git/',
      \   '\[.*\]'
      \ ], '\|') . "'"

" @return {List} recently used and still-existing files
function! dko#GetMru() abort
  " Reversed(Readable(Whitelist))
  return reverse(filter(
        \   filter(copy(v:oldfiles), s:mru_blacklist),
        \   'filereadable(expand(v:val))'
        \ ))
endfunction

" @return {List} listed buffers
function! dko#GetBuffers() abort
  return map(
        \ filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'
        \ )
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


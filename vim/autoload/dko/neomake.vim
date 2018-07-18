" autoload/dko/neomake.vim

" Add maker to buffer-local enabled_makers
"
" @param {string} ft
" @param {string} maker
function! dko#neomake#AddMaker(ft, maker) abort
  let l:bmakers = 'b:neomake_' . a:ft . '_enabled_makers'

  if exists(l:bmakers)
    if index({l:bmakers}, a:maker) > -1 | return | endif
    let {l:bmakers} += [ a:maker ]
    return
  endif

  try
    let l:makersfn = 'neomake#makers#ft#' . a:ft . '#EnabledMakers'
    let {l:bmakers} = call(l:makersfn, []) + [ a:maker ]
  catch
    let {l:bmakers} = [ a:maker ]
  endtry
endfunction

" Might as well be here since echint is created for all fts
"
" @param {dict} settings to make an npx maker with
" @param {mixed} [1] pass to just return the resulting dict, omit to set on b:
" @return {dict}
function! dko#neomake#NpxMaker(settings, ...) abort
  " eval to runs with the buffer context
  if has_key(a:settings, 'when') && !eval(a:settings['when']) | return | endif

  let l:bin = get(a:settings, 'npx', a:settings['maker'])
  let l:args = get(a:settings, 'args', [])
  let l:ft = get(a:settings, 'ft', neomake#utils#get_ft_confname(&filetype))
  let l:maker = extend(copy(a:settings), {
      \   'exe': 'npx',
      \   'args': [ '--quiet', l:bin ] + l:args,
      \ })
  if !has_key(a:settings, 'cwd')
    let l:maker.cwd = '%:p:h'
  endif

  if a:0 == 0
    let b:neomake_{l:ft}_{a:settings['maker']}_maker = l:maker
  endif

  return l:maker
endfunction

function! dko#neomake#CanMake(...) abort
  let l:bufnr = get(a:, 1, '%')
  return !dko#IsNonFile(l:bufnr) && !dko#IsHelp(l:bufnr)
        \ && !empty(getbufvar(l:bufnr, '&filetype'))
endfunction

" @TODO can use neomake#configure#automake() when blacklist is implemented
function! dko#neomake#MaybeRun() abort
  if !dko#neomake#CanMake('%') | return | endif
  Neomake
endfunction

" ============================================================================
" ECHint
" ============================================================================

function! g:PostprocessEchint(entry) abort
  return a:entry.text =~# 'did not pass EditorConfig validation'
        \ ? extend(a:entry, { 'valid': -1 })
        \ : a:entry
endfunction

" Excludes things like python, which has pep8.
let g:echint_whitelist = [
      \   'gitconfig',
      \   'dosini',
      \   'javascript',
      \   'json',
      \   'lua',
      \   'markdown',
      \   'php',
      \   'sh',
      \   'vim',
      \   'yaml',
      \]

function! dko#neomake#EchintCreate() abort
  let l:fts = g:echint_whitelist
  for l:ft in l:fts
    let g:neomake_{l:ft}_echint_maker = dko#neomake#NpxMaker({
          \   'maker': 'echint',
          \   'ft': l:ft,
          \   'errorformat': '%E%f:%l %m',
          \   'postprocess': function('PostprocessEchint'),
          \ }, 'global')
  endfor
endfunction

" For each filetype in the above whitelist, try to setup echint as
" a buffer-local maker, extending the current list of buffer-local makers (or
" default list)
function! dko#neomake#EchintSetup() abort
  if !dko#neomake#CanMake('%') | return | endif
  " @TODO also skip things that have automatic Neoformat enabled

  let l:safeft = neomake#utils#get_ft_confname(&filetype)
  if exists('b:did_echint_' . l:safeft) | return | endif
  let b:did_echint_{l:safeft} = 1

  let l:config = dko#project#GetFile('.editorconfig')
  if empty(l:config) | return | endif

  let l:cwd = fnamemodify(l:config, ':p:h')

  let l:fts = neomake#utils#get_config_fts(&filetype)

  let l:capable_fts = filter(l:fts, 'index(g:echint_whitelist, v:val) != -1')
  for l:ft in l:capable_fts
    if !exists('g:neomake_' . l:ft . '_echint_maker') | continue | endif
    let b:neomake_{l:ft}_echint_maker = copy(g:neomake_{l:ft}_echint_maker)
    let b:neomake_{l:ft}_echint_maker.cwd = l:cwd
    if get(b:, 'echint_enabled', 1) " enabled by default
      call dko#neomake#AddMaker(l:ft, 'echint')
    endif
  endfor
endfunction

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

function! dko#neomake#echint#CreateMaker() abort
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
function! dko#neomake#echint#Setup() abort
  if !dko#IsTypedFile('%') | return | endif
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

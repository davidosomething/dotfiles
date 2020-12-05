" ============================================================================
" ECHint
" ============================================================================

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
    let l:safe_ft = neomake#utils#get_ft_confname(l:ft)
    let l:neomake_var = 'neomake_' . l:safe_ft . '_echint_maker'
    if !exists('g:' . l:neomake_var) | continue | endif
    let b:{l:neomake_var} = copy(g:{l:neomake_var})
    let b:{l:neomake_var}.cwd = l:cwd
    if get(b:, 'echint_enabled', 1) " enabled by default
      call dko#neomake#AddMaker(l:ft, 'echint')
    endif
  endfor
endfunction

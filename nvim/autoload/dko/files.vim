" autoload/dko/files.vim

" ============================================================================
" MRU based on v:oldfiles
" ============================================================================

let s:mru_blacklist = join([
      \   '.git/',
      \   'NERD_tree',
      \   'NetrwTreeListing',
      \   '^/tmp/',
      \   'fugitive:',
      \   'vim/runtime/doc',
      \ ], '|')

" @return {List} recently used and still-existing files
function! dko#files#GetMru() abort
  return get(s:, 'mru_cache', dko#files#RefreshMru())
endfunction

function! dko#files#RefreshMru() abort
  let s:mru_cache =
        \ dko#ShortPaths(map(
        \   filter(
        \     copy(v:oldfiles),
        \     'filereadable(v:val) && v:val !~ "\\v(' . s:mru_blacklist . ')"'
        \   ),
        \   'expand(v:val)'
        \ ))
  return s:mru_cache
endfunction

function! dko#files#UpdateMru(file) abort
  if dko#IsEditable('%')
    let s:mru_cache = add(get(s:, 'mru_cache', []), a:file)
  endif
endfunction

augroup dkomru
  autocmd!
  autocmd dkomru BufAdd,BufNew,BufFilePost *
        \ call dko#files#UpdateMru(expand('<amatch>'))
augroup END

" ============================================================================
" Clean buffer names
" ============================================================================

" @return {List} listed buffers
function! dko#files#GetBuffers() abort
  return map(
        \   filter(range(1, bufnr('$')), 'buflisted(v:val) && !empty(v:val)'),
        \   'bufname(v:val)'
        \ )
endfunction

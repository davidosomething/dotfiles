" autoload/dko/files.vim

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
function! dko#files#GetMru() abort
  " Shortened(Readable(Whitelist)
  return dko#ShortPaths(filter(copy(v:oldfiles), s:mru_blacklist))
endfunction

" @return {List} listed buffers
function! dko#files#GetBuffers() abort
  return map(
        \   filter(range(1, bufnr('$')), 'buflisted(v:val) && !empty(v:val)'),
        \   'bufname(v:val)'
        \ )
endfunction

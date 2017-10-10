" autoload/dko/files.vim

" ============================================================================
" MRU based on v:oldfiles
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
  return get(s:, 'mru_cache', dko#files#RefreshMru())
endfunction

function! dko#files#RefreshMru() abort
  let s:mru_cache = dko#ShortPaths(filter(copy(v:oldfiles), s:mru_blacklist))
  return s:mru_cache
endfunction

augroup dkomru
  autocmd! dkomru BufAdd,BufNew,BufFilePost * call dko#files#RefreshMru()
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

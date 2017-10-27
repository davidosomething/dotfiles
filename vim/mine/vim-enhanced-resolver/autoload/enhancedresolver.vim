function! enhancedresolver#ResolveCursor() abort
  let l:request = expand('<cWORD>')
  let l:basepath = expand('%:p:h')
  let l:basepath = empty(l:basepath) ? getcwd() : l:basepath
  let l:result = substitute(system(join([
        \   'enhancedresolve',
        \   '--basepath', l:basepath,
        \   l:request,
        \ ], ' ')), '\n', '', 'g')
  return l:result
endfunction

function! enhancedresolver#GoCursor() abort
  let l:result = enhancedresolver#ResolveCursor()
  if empty(l:result) || !filereadable(l:result) | return | endif
  silent! execute 'edit ' . l:result
endfunction

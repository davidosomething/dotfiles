" autoload/dkoproject/tests.vim

function! dkoproject#tests#FindSpecs() abort
  let l:file_dir = expand('%:p:h')
  let l:dirs = filter([
        \   l:file_dir . '/tests',
        \   l:file_dir . '/__tests__',
        \   dkoproject#GetRoot() . '/tests',
        \   dkoproject#GetRoot() . '/__tests__',
        \ ], 'isdirectory(v:val)')
  let l:tests_dir = dko#First(l:dirs)
  let l:files = empty(l:tests_dir)
        \ ? []
        \ : globpath(l:tests_dir, '**/*.test.*', 0, 1)
        \ + globpath(l:tests_dir, '**/*.spec.*', 0, 1)
  return l:files
endfunction

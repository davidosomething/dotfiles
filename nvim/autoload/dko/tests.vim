" autoload/dko/tests.vim

let s:dir_candidates = [ '/tests', '/__tests__' ]
let s:glob_candidates = [ '**/*.test.*', '**/*.spec.*' ]

" Look near current file or in project root; in s:dir_candidates dirs for
" files matching s:glob_candidates
function! dko#tests#FindTests() abort
  let l:file_dir = expand('%:p:h:t')
  let l:file_path = expand('%:p:h')

  " If we're IN a tests dir, don't look in s:dir_candidates
  let l:dirs = l:file_dir =~? 'tests' ? [ '' ] : s:dir_candidates

  let l:candidates = []
  " Look near current file, maybe in tests dir if not already in one
  let l:candidates += map(copy(l:dirs), 'l:file_path . v:val')
  " Look in project root /__tests__ and /tests
  let l:candidates += map(copy(s:dir_candidates),
        \ 'dko#project#GetRoot() . v:val')
  let l:actual = dko#First(filter(l:candidates, 'isdirectory(v:val)'))
  if empty(l:actual) | return [] | endif

  let l:results = []
  for l:glob in s:glob_candidates
    let l:results += globpath(l:actual, l:glob, 0, 1)
  endfor
  return dko#Unique(l:results)
endfunction

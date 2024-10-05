function! ale#other_source#ShowResults(buffer, linter_name, loclist) abort
  call luaeval("require('ale-shim').convert_to_vim_diagnostic(_A[1], _A[2], _A[3])", [ a:buffer, a:linter_name, a:loclist ])
endfunction

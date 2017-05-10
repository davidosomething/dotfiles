function! g:DKO_Spacing() abort
  setlocal expandtab                         " default to spaces instead of tabs
  setlocal shiftwidth=2                      " softtabs are 2 spaces for expandtab

  " Alignment tabs are two spaces, and never tabs. Negative means use same as
  " shiftwidth (so the 2 actually doesn't matter).
  if v:version >= 704
    setlocal softtabstop=-2
  endif

  " real tabs render width. Applicable to HTML, PHP, anything using real tabs.
  " I.e., not applicable to JS.
  setlocal tabstop=2
endfunction

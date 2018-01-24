" after/plugin/squarespace.vim

if !exists('$SQSP') | finish | endif

augroup squarespace
  autocmd!

  if dkoplug#IsLoaded('neomake')
    " There is no b: for this option
    autocmd BufNewFile,BufReadPre */sqsp/*
          \ let g:neomake_java_checkstyle_xml =
          \   expand('$SQSP/squarespace-styleguide/squarespace-checkstyle.xml')
  endif

  autocmd BufNewFile,BufReadPre */squarespace-v6/site-server/*
        \ call dko#project#SetRoot(expand('$SQSP/squarespace-v6/site-server'))

augroup END

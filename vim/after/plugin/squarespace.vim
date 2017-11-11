" after/plugin/squarespace.vim

augroup squarespace
  autocmd!

  " autocmd squarespace BufNewFile,BufReadPre */sqsp/*
  "       \ setlocal noeol

  if dkoplug#plugins#IsLoaded('neomake')
    autocmd BufNewFile,BufReadPre */sqsp/*
          \ let g:neomake_java_checkstyle_xml =
          \   expand('$SQSP/squarespace-styleguide/squarespace-checkstyle.xml')
  endif
augroup END

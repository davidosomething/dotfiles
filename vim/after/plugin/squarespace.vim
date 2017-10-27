" after/plugin/squarespace.vim

augroup squarespace
  autocmd!

  " autocmd squarespace BufNewFile,BufReadPre */sqsp/*
  "       \ setlocal noeol

  if dkoplug#plugins#IsLoaded('neomake')
    autocmd squarespace BufNewFile,BufReadPre */sqsp/*
          \ let g:neomake_java_checkstyle_xml =
          \   expand('$SQSP/squarespace-styleguide/squarespace-checkstyle.xml')
    autocmd squarespace BufNewFile,BufReadPre */site-server/*
          \ let b:neomake_javascript_eslint_exe =
          \   expand('$SQSP/squarespace-v6/site-server/node_modules/.bin/eslint')
  endif
augroup END

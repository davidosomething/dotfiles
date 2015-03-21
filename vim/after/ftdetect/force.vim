" Force filetypes
"
" see *ftdetect* in vim filetype help
" http://vimdoc.sourceforge.net/htmldoc/filetype.html

" No autocmd group needed -- vim automatically creates one for stuff in
" ftdetect/
augroup ForceFiletypes
  autocmd!
  au BufRead,BufNewFile *.bowerrc         setlocal filetype=json
  au BufRead,BufNewFile *.cap             setlocal filetype=ruby
  au BufRead,BufNewFile *.conf            setlocal filetype=conf
  au BufRead,BufNewFile *.dump            setlocal filetype=sql
  au BufRead,BufNewFile *.editorconfig    setlocal filetype=json
  au BufRead,BufNewFile *.jshintrc        setlocal filetype=json
  " md is normally modula2 -- force it to always be markdown
  au BufRead,BufNewFile *.md              setlocal filetype=markdown
  au BufRead,BufNewFile *.rules           setlocal filetype=javascript
  au BufRead,BufNewFile *.txt             setlocal filetype=markdown
augroup END

" filetype.vim
"
" see *ftdetect* in vim filetype help
" http://vimdoc.sourceforge.net/htmldoc/filetype.html
" Runs on "filetype on"
"

if exists("did_load_filetypes")
  finish
endif

" only useful for filetypes that can be detected by filename
" it is option C in the docs
augroup filetypedetect
  autocmd BufRead,BufNewFile *.bowerrc         setfiletype json
  autocmd BufRead,BufNewFile *.cap             setfiletype ruby
  autocmd BufRead,BufNewFile *.conf            setfiletype conf
  autocmd BufRead,BufNewFile *.dump            setfiletype sql
  autocmd BufRead,BufNewFile *.editorconfig    setfiletype json
  autocmd BufRead,BufNewFile *.jshintrc        setfiletype json
  " md is normally modula2 -- force it to always be markdown
  autocmd BufRead,BufNewFile *.md              setfiletype markdown
  autocmd BufRead,BufNewFile *.rules           setfiletype javascript
  autocmd BufRead,BufNewFile *.txt             setfiletype markdown
augroup END


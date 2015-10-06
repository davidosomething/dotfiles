" filetype.vim
"
" see *ftdetect* in vim filetype help
" http://vimdoc.sourceforge.net/htmldoc/filetype.html
" Runs on filetype on
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
  autocmd BufRead,BufNewFile *.eslintrc        setfiletype json
  autocmd BufRead,BufNewFile *.jshintrc        setfiletype json
  autocmd BufRead,BufNewFile *.rules           setfiletype javascript
augroup END

autocmd BufRead,BufNewFile *.php             setlocal filetype=php

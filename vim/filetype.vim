" filetype.vim
"
" This needs to be first -- don't move into after/ or else some manually
" defined ftplugins won't load
"
" These do NOT get overridden -- see *ftdetect* in vim filetype help
" http://vimdoc.sourceforge.net/htmldoc/filetype.html
"
" Runs on `filetype on`
"

if exists('g:did_load_filetypes_user') | finish | endif
let g:did_load_filetypes_user = 1

" only useful for filetypes that can be detected by filename
" it is option C in the docs
augroup filetypedetect

  " conf files ---------------------------------------------------------------
  " autocmd BufRead,BufNewFile *.conf
  "       \ setfiletype conf

  " nginx conf files have their own plugin syntax nginx
  " First au is for sudoediting temp files
  autocmd BufRead,BufNewFile *nginx*.conf
        \ setfiletype nginx
  autocmd BufRead,BufNewFile /etc/nginx/**/*.conf
        \ setfiletype nginx

  " other files --------------------------------------------------------------

  autocmd BufRead,BufNewFile,BufFilePre *.cap           setfiletype ruby

  autocmd BufRead,BufNewFile,BufFilePre *.dump          setfiletype sql

  autocmd BufRead,BufNewFile,BufFilePre .babelrc        setfiletype json
  autocmd BufRead,BufNewFile,BufFilePre .bowerrc        setfiletype json
  autocmd BufRead,BufNewFile,BufFilePre .editorconfig   setfiletype json
  autocmd BufRead,BufNewFile,BufFilePre .eslintrc       setfiletype json
  autocmd BufRead,BufNewFile,BufFilePre .jscsrc         setfiletype json
  autocmd BufRead,BufNewFile,BufFilePre .jshintrc       setfiletype json

  autocmd BufRead,BufNewFile,BufFilePre *.md            setfiletype markdown.pandoc
  autocmd BufRead,BufNewFile,BufFilePre *.txt           setfiletype markdown.pandoc

  " polkit rules files
  autocmd BufRead,BufNewFile,BufFilePre *.rules         setfiletype javascript

augroup END

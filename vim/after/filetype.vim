" after/filetype.vim
"
" see *ftdetect* in vim filetype help
" http://vimdoc.sourceforge.net/htmldoc/filetype.html
" Runs on filetype on
"

if exists('g:did_load_filetypes_userafter') | finish | endif
let g:did_load_filetypes_userafter = 1

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

  autocmd BufRead,BufNewFile *.cap             setfiletype ruby

  autocmd BufRead,BufNewFile *.dump            setfiletype sql

  autocmd BufRead,BufNewFile *.babelrc         setfiletype json
  autocmd BufRead,BufNewFile *.bowerrc         setfiletype json
  autocmd BufRead,BufNewFile *.editorconfig    setfiletype json
  autocmd BufRead,BufNewFile *.eslintrc        setfiletype json
  autocmd BufRead,BufNewFile *.jshintrc        setfiletype json

  " polkit rules files
  autocmd BufRead,BufNewFile *.rules           setfiletype javascript

augroup END

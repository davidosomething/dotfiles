" filetype.vim
"
" see *ftdetect* in vim filetype help
" http://vimdoc.sourceforge.net/htmldoc/filetype.html
" Runs on filetype on
"

if exists("did_load_filetypes") | finish | endif

" only useful for filetypes that can be detected by filename
" it is option C in the docs
augroup filetypedetect

  " conf files ---------------------------------------------------------------
  autocmd BufRead,BufNewFile *.conf            setfiletype conf

  " nginx conf files have their own plugin syntax nginx
  autocmd BufRead,BufNewFile /etc/nginx/**/*.conf
        \ setfiletype nginx

  " polkit conf files are javascript
  autocmd BufRead,BufNewFile /etc/polkit-1/**/*.conf
        \ setfiletype javascript

  " other files --------------------------------------------------------------

  autocmd BufRead,BufNewFile *.bowerrc         setfiletype json
  autocmd BufRead,BufNewFile *.cap             setfiletype ruby
  autocmd BufRead,BufNewFile *.dump            setfiletype sql
  autocmd BufRead,BufNewFile *.editorconfig    setfiletype json
  autocmd BufRead,BufNewFile *.eslintrc        setfiletype json
  autocmd BufRead,BufNewFile *.jshintrc        setfiletype json
  autocmd BufRead,BufNewFile *.rules           setfiletype javascript

augroup END

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

  autocmd BufNewFile,BufRead,BufFilePost *.cap    setfiletype ruby

  autocmd BufNewFile,BufRead,BufFilePost *.dump   setfiletype sql

  " git branch description (opened via `git branch --edit-description`)
  autocmd BufNewFile,BufRead,BufFilePost BRANCH_DESCRIPTION
        \ setfiletype gitbranchdescription.markdown.pandoc

  autocmd BufNewFile,BufRead,BufFilePost *.md   setfiletype markdown.pandoc

  autocmd BufNewFile,BufRead,BufFilePost .babelrc   setfiletype json
  autocmd BufNewFile,BufRead,BufFilePost .bowerrc   setfiletype json
  autocmd BufNewFile,BufRead,BufFilePost .eslintrc  setfiletype json
  autocmd BufNewFile,BufRead,BufFilePost .jscsrc    setfiletype json
  autocmd BufNewFile,BufRead,BufFilePost .jshintrc  setfiletype json

  autocmd BufRead,BufNewFile,BufFilePost */nginx/*.conf   setfiletype nginx
  autocmd BufRead,BufNewFile,BufFilePost /*/nginx/*.conf  setfiletype nginx

  " polkit rules files
  autocmd BufNewFile,BufRead,BufFilePost *.rules  setfiletype javascript

augroup END


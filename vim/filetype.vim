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

" For files that might be JSON or YAML, read first line and use that
function! s:SetJSONorYAML()
  if getline(1) ==# '{'
    setfiletype json
    return
  endif
  setfiletype yaml
endfunction

function! s:BindPreview()
  if exists('$ITERM_PROFILE') || has('gui_macvim')
    nnoremap  <silent><buffer><special>  <Leader>m
          \ :<C-U>silent !open -a "Marked 2" '%:p'<CR>
  elseif dko#IsPlugged('vim-instant-markdown')
    let g:instant_markdown_autostart = 0
    nnoremap  <silent><buffer><special>  <Leader>m
          \ :<C-U>InstantMarkdownPreview<CR>
  endif
endfunction

" For filetypes that can be detected by filename (option C in the docs for
" `new-filetype`)
" Use `autocmd!` so the original filetype autocmd for the given extension gets
" cleared (otherwise it will run, and then this one, possible causing two
" filetype events to execute in succession)
augroup filetypedetect

  autocmd! BufNewFile,BufRead
        \ *.cap
        \ setfiletype ruby

  autocmd! BufNewFile,BufRead
        \ *.dump
        \ setfiletype sql

  " git branch description (opened via `git branch --edit-description`)
  autocmd! BufNewFile,BufRead
        \ BRANCH_DESCRIPTION
        \ setfiletype gitbranchdescription.markdown

  " pre Vim 7.4.480 - md is modula2
  " post Vim 7.4.480 - md is markdown
  autocmd! BufNewFile,BufRead *.md
        \ setfiletype markdown
        \| call s:BindPreview()

  autocmd! BufNewFile,BufRead
        \ .babelrc,.bowerrc,.jshintrc
        \ setfiletype json

  autocmd! BufNewFile,BufRead
        \ .eslintrc,.stylelintrc
        \ call s:SetJSONorYAML()

  autocmd! BufRead,BufNewFile
        \ */nginx*.conf,/*/nginx*.conf
        \ setfiletype nginx

  " polkit rules files
  autocmd! BufNewFile,BufRead
        \ *.rules
        \ setfiletype javascript

augroup END


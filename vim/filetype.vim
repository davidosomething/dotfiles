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

function! s:SetByShebang() abort
  let l:shebang = getline(1)
  if l:shebang =~# '^#!.*/.*\s\+node\>' | setfiletype javascript | endif
  if l:shebang =~# '^#!.*/.*\s\+zsh\>' | setfiletype zsh | endif
endfunction

" For filetypes that can be detected by filename (option C in the docs for
" `new-filetype`)
" Use `autocmd!` so the original filetype autocmd for the given extension gets
" cleared (otherwise it will run, and then this one, possible causing two
" filetype events to execute in succession)
augroup filetypedetect
  " pangloss/vim-javascript provides this
  autocmd! BufNewFile,BufRead * call s:SetByShebang()

  autocmd! BufNewFile,BufRead *.dump setfiletype sql
  autocmd! BufNewFile,BufRead .flake8 setfiletype dosini

  autocmd! BufNewFile,BufRead *.gitconfig setfiletype gitconfig

  " git branch description (opened via `git branch --edit-description`)
  autocmd! BufNewFile,BufRead BRANCH_DESCRIPTION
        \ setfiletype gitbranchdescription.markdown

  " marko templating, close enough to HTML
  autocmd! BufNewFile,BufRead *.marko setfiletype html.marko
  autocmd! BufNewFile,BufRead *.template setfiletype html

  autocmd! BufNewFile,BufRead */nginx*.conf,/*/nginx*.conf setfiletype nginx

  autocmd! BufNewFile,BufRead *.njk setfiletype jinja

  autocmd! BufNewFile,BufRead *.plist setfiletype xml

  " ironic that it doesn't use a .yml/.yaml extension
  autocmd! BufNewFile,BufRead .yamllint,workflows setfiletype yaml
augroup END

" most of these are added to $VIMRUNTIME/filetype.vim now
if v:version < 800
  augroup filetypedetect
    autocmd! BufNewFile,BufRead *.gradle setfiletype groovy
    autocmd! BufNewFile,BufRead *.md setfiletype markdown

    autocmd! BufNewFile,BufRead *.js,*.jsx setfiletype javascriptreact
    autocmd! BufNewFile,BufRead *.tsx setfiletype typescriptreact

    " polkit rules files
    autocmd! BufNewFile,BufRead *.rules setfiletype javascript

    autocmd! BufNewFile,BufRead .zprofile setfiletype zsh
  augroup END
endif

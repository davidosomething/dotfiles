" after/ftplugin/gitcommit.vim
"
" Nice big git commit message window
" Only runs in a vim server named GIT (probably opened via my "e" script)
"

setlocal comments=:;
setlocal wrap
setlocal linebreak
setlocal spell
setlocal complete+=kspell

" override settings that were undone by @gtd in tpope/vim-git
setlocal textwidth=80

" after/ftplugin/markdown.vim
" This is run AFTER after/ftplugin/html.vim
" It needs to explicitly override anything there

setlocal nomodeline
setlocal spell
setlocal nocopyindent
setlocal wrap
setlocal expandtab
setlocal linebreak
setlocal textwidth=80

" Always start in display movement mode for markdown
call movemode#setByDisplay()


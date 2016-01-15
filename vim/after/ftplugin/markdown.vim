" after/ftplugin/markdown.vim
"
" There are additional settings in ftplugin/markdown.vim that are set for
" plugins that need variables set before loading.
"
" This is run AFTER after/ftplugin/html.vim
" It needs to explicitly override anything there
"

setlocal nomodeline
setlocal spell
setlocal nocopyindent
setlocal nowrap
setlocal expandtab
setlocal nolinebreak
setlocal textwidth=0
setlocal nosmartindent
setlocal nocindent

" Always start in display movement mode for markdown
call movemode#setByDisplay()


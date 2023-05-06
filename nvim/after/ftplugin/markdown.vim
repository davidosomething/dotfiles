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

" Override pandoc
setlocal textwidth=78
" the line will be right after column 80, &tw+3
setlocal colorcolumn=+3

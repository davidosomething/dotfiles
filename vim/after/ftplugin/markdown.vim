" after/ftplugin/markdown.vim
"
" There are additional settings in ftplugin/markdown.vim that are set for
" plugins that need variables set before loading.
"
" This is run AFTER after/ftplugin/html.vim
" It needs to explicitly override anything there
"

setlocal nomodeline
setlocal expandtab
setlocal textwidth=0
setlocal spell

" too slow
"setlocal complete+=kspell

" Don't automatically close xml-taglike things
" Since markdown includes the html filetype, othree/xml.vim tries to close
" anything that looks like a <tag> including markdown autolinks, e.g.,
" `<http://google.com>`
iunmap   <buffer>  >

" Always start in display movement mode for markdown
silent! call dkomovemode#setByDisplay()


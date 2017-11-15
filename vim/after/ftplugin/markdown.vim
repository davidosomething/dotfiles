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
setlocal spell

" Override pandoc
setlocal textwidth=78
" the line will be right after column 80, &tw+3
setlocal colorcolumn=+3

" too slow
"setlocal complete+=kspell

" Always start in display movement mode for markdown
silent! call movemode#Display()

if exists('$ITERM_PROFILE') || has('gui_macvim')
  let s:cpo_save = &cpoptions
  set cpoptions&vim

  nnoremap  <silent><buffer><special>  <Leader>m
        \ :<C-U>silent !open -a "Marked 2" '%:p'<CR>

  let &cpoptions = s:cpo_save
  unlet s:cpo_save
endif

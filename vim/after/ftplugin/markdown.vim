" after/ftplugin/markdown.vim
" This is run AFTER after/ftplugin/html.vim
" It needs to explicitly override anything there

setlocal nomodeline
setlocal spell
setlocal nocopyindent
setlocal nowrap
setlocal expandtab
setlocal nolinebreak
setlocal textwidth=0

" Always start in display movement mode for markdown
call movemode#setByDisplay()

augroup markdown
  autocmd filetype markdown.pandoc
        \ nnoremap <silent><buffer> <Leader>m :InstantMarkdownPreview<CR>
augroup end


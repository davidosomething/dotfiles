" ftplugin/vim.vim

call dko#TwoSpace()
setlocal keywordprg=:help
setlocal omnifunc=syntaxcomplete#Complete

if expand('%') =~# 'dkoplug/plugins.vim'
  nnoremap <buffer><silent> gx :<C-U>call dkoplug#browse#gx()<CR>
endif

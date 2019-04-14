" after/ftplugin/vim.vim

call dko#TwoSpace()

setlocal iskeyword-=#
setlocal keywordprg=:help
setlocal omnifunc=syntaxcomplete#Complete

if expand('%') =~# 'dkoplug/plugins.vim'
  let s:cpo_save = &cpoptions
  set cpoptions&vim

  nnoremap <buffer><silent> gx :<C-U>call dkoplug#browse#gx()<CR>

  let &cpoptions = s:cpo_save
  unlet s:cpo_save
endif

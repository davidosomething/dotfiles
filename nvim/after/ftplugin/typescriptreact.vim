" after/ftplugin/typescriptreact.vim

setlocal formatoptions+=crj

if !dko#PrettierSpace()
  call dko#TwoSpace()
endif

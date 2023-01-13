" ftplugin/typescript.vim

setlocal suffixesadd+=.js,.jsx,.tsx,.vue,.json

if !dko#PrettierSpace()
  call dko#TwoSpace()
endif

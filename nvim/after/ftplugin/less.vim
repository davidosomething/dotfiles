" after/ftplugin/less.vim

call dko#TwoSpace()
setlocal iskeyword+=-
setlocal includeexpr=substitute(v:fname,'\\%(.*/\\\|^\\)\\zs','_','')

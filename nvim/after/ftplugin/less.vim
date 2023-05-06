" after/ftplugin/less.vim

setlocal iskeyword+=-
setlocal includeexpr=substitute(v:fname,'\\%(.*/\\\|^\\)\\zs','_','')

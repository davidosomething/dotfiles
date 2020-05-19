" after/ftplugin/less.vim

call dko#TwoSpace()
setlocal iskeyword+=-
setlocal includeexpr=substitute(v:fname,'\\%(.*/\\\|^\\)\\zs','_','')

if dkoplug#IsLoaded('jumpy.vim')
  call jumpy#map('^[^ \t{}/]', '')
endif

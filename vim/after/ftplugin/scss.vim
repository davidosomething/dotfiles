" after/ftplugin/scss.vim

call dko#TwoSpace()
setlocal iskeyword+=-

if dkoplug#IsLoaded('jumpy.vim')
  call jumpy#map('^[^ \t{}/]', '')
endif

if !exists('g:vimlint#config')
  let g:vimlint#config = {}
endif

let g:vimlint#config.EVL103 = 1

if exists("g:plugs['syntastic']")
  let g:syntastic_vimlint_options = g:vimlint#config
endif


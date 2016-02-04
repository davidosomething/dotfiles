if !exists("g:plugs['increment-activator']") | finish | endif

let g:increment_activator_filetype_candidates = {
      \   'gitrebase': [
      \     ['pick', 'squash'],
      \   ],
      \   'javascript': [
      \     [ 'var', 'const', 'let' ],
      \     [ 'private', 'public' ],
      \     [ 'Boolean', 'Error', 'Number', 'Object', 'String' ],
      \   ],
      \   'php': [
      \     [ 'private', 'protected', 'public', 'var' ],
      \     [ 'extends', 'implements' ],
      \   ],
      \   'vim': [
      \     ['nnoremap', 'xnoremap', 'inoremap', 'vnoremap', 'cnoremap', 'onoremap'],
      \     ['nmap', 'xmap', 'imap', 'vmap', 'cmap', 'omap'],
      \   ],
      \ }


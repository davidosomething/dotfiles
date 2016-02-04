if !exists("g:plugs['increment-activator']") | finish | endif

let g:increment_activator_filetype_candidates = {
      \   'javascript': [
      \     [ 'var', 'const', 'let' ],
      \     [ 'Boolean', 'Error', 'Number', 'Object', 'String' ],
      \   ],
      \   'git-rebase-todo': [
      \     ['pick', 'reword', 'edit', 'squash', 'fixup', 'exec'],
      \   ]
      \ }

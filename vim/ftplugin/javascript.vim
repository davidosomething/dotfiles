" ftplugin/javascript.vim

call dko#TwoSpace()

" Set up native eslint making so we can debug eslint configs
setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %trror\ -\ %m
setlocal errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %tarning\ -\ %m
setlocal errorformat+=%-G\s%#
setlocal errorformat+=%-G\s%#%\\d%\\+\ problems%#
let &l:makeprg = 'cd ' . dko#project#GetRoot() . ' && npx eslint'
      \. ' --config ' . dko#project#javascript#GetEslintrc()
      \. ' --format compact --no-color %'

" Automatically try these file extensions when gf to a word without extension
" .js is added by vim-jsx-improve
setlocal suffixesadd+=.jsx,.ts,.tsx,.vue,.json

if dkoplug#IsLoaded('coc.nvim')
  nmap <silent> <Leader>pd :<C-u>CocCommand docthis.documentThis<CR>
endif

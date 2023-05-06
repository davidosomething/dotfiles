" ftplugin/javascript.vim

" Set up native eslint making so we can debug eslint configs
setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %trror\ -\ %m
setlocal errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %tarning\ -\ %m
setlocal errorformat+=%-G\s%#
setlocal errorformat+=%-G\s%#%\\d%\\+\ problems%#

" Automatically try these file extensions when gf to a word without extension
" .js is added by vim-jsx-improve
setlocal suffixesadd+=.jsx,.ts,.tsx,.vue,.json

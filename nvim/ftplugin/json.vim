" ftplugin/json.vim

call dko#TwoSpace()
setlocal nowrap

if dkoplug#Exists('vim-json')
  let g:vim_json_syntax_conceal = 0
endif

let &l:errorformat =
      \   '%ELine %l:%c,%Z\\s%#Reason: %m,%C%.%#,'
      \ . '%f: line %l\, col %c\, %m,%-G%.%#'
let &l:makeprg = 'jsonlint --compact --quiet -- %'

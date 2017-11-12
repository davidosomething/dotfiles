" ftplugin/json.vim

call dko#TwoTabs()
setlocal nowrap

if dkoplug#Exists('vim-json')
  let g:vim_json_syntax_conceal = 0
endif

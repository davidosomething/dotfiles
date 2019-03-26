function! dko#coc#extensions#Install() abort
  CocInstall coc-css

  " Configurable eslint instead of using tsserver
  CocInstall coc-eslint

  " Color highlighting in non-css files too
  CocInstall coc-highlight

  CocInstall coc-json

  CocInstall coc-neosnippet
  CocInstall coc-snippets

  CocInstall coc-tsserver
  CocInstall coc-yaml
endfunction

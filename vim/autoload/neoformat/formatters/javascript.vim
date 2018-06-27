" autoload/neoformat/formatters/javascript.vim

function! neoformat#formatters#javascript#dkoprettier() abort
  return {
      \   'exe':    'prettier',
      \   'args':   [
      \     '--config', dko#project#javascript#GetPrettierrc(),
      \     '--stdin',
      \   ],
      \   'stdin':  1,
      \ }
endfunction

function! neoformat#formatters#javascript#dkoprettiereslint() abort
  return {
      \   'exe':    'prettier-eslint',
      \   'args':   [
      \     '--eslint-path', dko#project#GetRoot() . '/node_modules/eslint',
      \     '--eslint-config-path', dko#project#javascript#GetEslintrc(),
      \     '--config', dko#project#javascript#GetPrettierrc(),
      \     '--stdin',
      \   ],
      \   'stdin':  1,
      \ }
endfunction

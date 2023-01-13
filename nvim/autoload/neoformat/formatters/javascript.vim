" autoload/neoformat/formatters/javascript.vim

function! neoformat#formatters#javascript#dkoprettier() abort
  return {
      \   'exe': 'npx',
      \   'args': [
      \     'prettier',
      \     '--config', dko#project#GetPrettierrc(),
      \     '--stdin-filepath', '%:p',
      \     '--stdin',
      \   ],
      \   'stdin': 1,
      \ }
endfunction

function! neoformat#formatters#javascript#dkoprettiereslint() abort
  return {
      \   'exe': 'npx',
      \   'args': [
      \     'prettier-eslint',
      \     '--eslint-path', dko#project#GetRoot() . '/node_modules/eslint',
      \     '--eslint-config-path', dko#project#javascript#GetEslintrc(),
      \     '--config', dko#project#GetPrettierrc(),
      \     '--stdin-filepath', '%:p',
      \     '--stdin',
      \   ],
      \   'stdin': 1,
      \ }
endfunction

" autoload/neoformat/formatters/markdown.vim

function! neoformat#formatters#markdown#dkoremark() abort
  return {
        \   'exe': 'npx',
        \   'args': [ 'remark-cli', '--no-color', '--silent' ],
        \   'stdin': 1,
        \ }
endfunction

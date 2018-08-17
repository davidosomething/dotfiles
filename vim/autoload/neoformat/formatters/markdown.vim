" autoload/neoformat/formatters/markdown.vim

function! neoformat#formatters#markdown#dkoremark() abort
  return {
        \   'exe': 'npx',
        \   'args': [ 'remark-cli', '--no-color', '--silent' ],
        \   'stdin': 1,
        \ }
endfunction

function! neoformat#formatters#markdown#dkoprettier() abort
  let l:config = neoformat#formatters#javascript#dkoprettier()
  let l:config.args += [ '--parser', 'markdown' ]
  return l:config
endfunction

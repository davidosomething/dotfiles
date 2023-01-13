" autoload/neoformat/formatters/json.vim

function! neoformat#formatters#json#dkoprettier() abort
  let l:config = neoformat#formatters#javascript#dkoprettier()
  let l:config.args += [ '--parser', 'json' ]
  return l:config
endfunction

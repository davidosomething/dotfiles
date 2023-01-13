" autoload/neoformat/formatters/css.vim

function! neoformat#formatters#less#dkoprettier() abort
  let l:config = neoformat#formatters#javascript#dkoprettier()
  let l:config.args += [ '--parser', 'less' ]
  return l:config
endfunction

" autoload/neoformat/formatters/typescript.vim

function! neoformat#formatters#typescript#dkoprettier() abort
  return neoformat#formatters#javascript#dkoprettier()
endfunction

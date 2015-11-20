let g:committia_open_only_vim_starting = 1
let g:committia_use_singlecolumn = 'always'

let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
  setlocal spell
endfunction

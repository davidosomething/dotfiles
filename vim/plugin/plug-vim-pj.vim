" plugin/plug-vim-pj.vim

" Wrapper function to provide funcref for autoload function
"
" @return {String}
function! g:DKO_FindPackageJson() abort
  return dkoproject#GetFile('package.json')
endfunction
let g:PJ_function = function('g:DKO_FindPackageJson')

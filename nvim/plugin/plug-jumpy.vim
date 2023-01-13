" plugin/plug-vim-indent-guides.vim

augroup dkojumpy
  autocmd!
augroup END

if !dkoplug#IsLoaded('jumpy.vim') | finish | endif

function! s:MapCssish() abort
  call jumpy#map('^[^ \t{}/]', '')
endfunction

autocmd dkojumpy Filetype less,scss call s:MapCssish()

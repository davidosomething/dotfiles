" plugin/plug-vim-indent-guides.vim

if !dkoplug#IsLoaded('vim-lookup') | finish | endif

augroup dkovimlookup
  autocmd!
  autocmd FileType vim nnoremap <buffer><silent> gd
        \ :<C-U>call lookup#lookup()<CR>
augroup END

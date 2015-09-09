autocmd FileType javascript,css,php
      \ nnoremap <silent>;; :call cosco#commaOrSemiColon()<CR>
autocmd FileType javascript,css,php
      \ inoremap <silent>;; <C-O>:call cosco#commaOrSemiColon()<CR>

autocmd FileType javascript,css,php
      \ nnoremap <silent>,, :call cosco#commaOrSemiColon()<CR>
autocmd FileType javascript,css,php
      \ inoremap <silent>,, <C-O>:call cosco#commaOrSemiColon()<CR>

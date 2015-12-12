if !exists("g:plugs['cosco.vim']") | finish | endif

function! s:DKO_Cosco_Bindings()
  nnoremap <silent> ;; :call cosco#commaOrSemiColon()<CR>
  inoremap <silent> ;; <C-O>:call cosco#commaOrSemiColon()<CR>
  nnoremap <silent> ,, :call cosco#commaOrSemiColon()<CR>
  inoremap <silent> ,, <C-O>:call cosco#commaOrSemiColon()<CR>
endfunction

autocmd vimrc FileType javascript,css,php call s:DKO_Cosco_Bindings()

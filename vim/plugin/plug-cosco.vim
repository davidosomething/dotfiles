if !exists("g:plugs['cosco.vim']") | finish | endif

function! s:DKO_Cosco_Bindings()
  nnoremap <silent><buffer> ;; :<C-u>call cosco#commaOrSemiColon()<CR>
  inoremap <silent><buffer> ;; <C-O>:<C-u>call cosco#commaOrSemiColon()<CR>
  nnoremap <silent><buffer> ,, :call cosco#commaOrSemiColon()<CR>
  inoremap <silent><buffer> ,, <C-O>:<C-u>call cosco#commaOrSemiColon()<CR>
endfunction

augroup dkocosco
  autocmd!
  autocmd dkocosco FileType javascript,css,php call s:DKO_Cosco_Bindings()
augroup END


" ============================================================================
" HR - Insert line fill to textwidth
" ============================================================================

" http://stackoverflow.com/a/3400528/230473
function! g:DKO_Rule(str)
  " set tw to the desired total length
  let l:tw = &textwidth
  if l:tw == 0 | let l:tw = 80 | endif

  " strip trailing spaces first
  .s/[[:space:]]*$//

  " calculate total number of 'str's to insert
  let l:reps = (l:tw - col('$')) / len(a:str)

  " insert them, if there's room, removing trailing spaces (though forcing
  " there to be one)
  if l:reps > 0
    .s/$/\=(' '.repeat(a:str, reps))/
  endif
endfunction

inoremap <Leader>f- <Esc>:call g:DKO_Rule('-')<CR>
inoremap <Leader>f= <Esc>:call g:DKO_Rule('=')<CR>
inoremap <Leader>f# <Esc>:call g:DKO_Rule('#')<CR>
inoremap <Leader>f* <Esc>:call g:DKO_Rule('*')<CR>
nnoremap <Leader>f- :call g:DKO_Rule('-')<CR>
nnoremap <Leader>f= :call g:DKO_Rule('=')<CR>
nnoremap <Leader>f# :call g:DKO_Rule('#')<CR>
nnoremap <Leader>f* :call g:DKO_Rule('*')<CR>


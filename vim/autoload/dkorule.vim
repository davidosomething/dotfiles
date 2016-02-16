" autoload/dkorule.vim

" Generate a line of a:char from current cursor to end of textwidth
" http://stackoverflow.com/a/3400528/230473
function! dkorule#char(char) abort
  let l:tw = getbufvar('%', '&textwidth', 78)
  let l:tw = l:tw ? l:tw : 78
  let l:reps = l:tw - (col('$') - 1)
  if l:reps > 0
    execute 'normal! ' . l:reps . 'A' . a:char
  endif
endfunction

" Map key
function! dkorule#map(char) abort
  let l:command = ':<C-u>call dkorule#char("' . a:char . '")<CR>'
  execute 'nnoremap <silent><special> <Leader>f' . a:char . ' ' . l:command
  execute 'inoremap <silent><special> <Leader>f' . a:char . ' <C-o>' . l:command
endfunction


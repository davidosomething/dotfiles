" autoload/dkorule.vim

" Generate a line of a:char from current cursor to end of textwidth
" http://stackoverflow.com/a/3400528/230473
function! dkorule#char(char) abort
  let l:tw = getbufvar('%', '&textwidth', 78)
  let l:reps = l:tw - (col('$') - 1)
  if l:reps > 0
    execute 'normal! ' . l:reps . 'A' . a:char
  endif
endfunction

" Map key
function! dkorule#map(char) abort
  let l:key = '<Leader>f' . a:char
  execute 'nnoremap <silent> ' . l:key . ' :<C-u>call dkorule#char("' . a:char . '")<CR>'
  execute 'imap ' . l:key . ' <C-o>' . l:key
endfunction


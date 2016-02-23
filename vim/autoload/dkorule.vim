" autoload/dkorule.vim

" Generate a line of a:char from current cursor to end of textwidth
" http://stackoverflow.com/a/3400528/230473
function! dkorule#char(char) abort
  if !strlen(a:char) | return | endif
  let l:tw = getbufvar('%', '&textwidth', 78)
  let l:tw = l:tw ? l:tw : 78
  let l:available = l:tw - (col('$') - 1)
  let l:available = l:available > 0 ? l:available : 0
  let l:reps = float2nr(floor(l:available / strlen(a:char)))
  if !l:reps | return | endif
  execute 'normal! ' . l:reps . 'A' . a:char
endfunction

" Map key
function! dkorule#map(char) abort
  let l:command = ':<C-u>call dkorule#char("' . a:char . '")<CR>'
  execute 'nnoremap <silent><special> <Leader>f' . a:char . ' ' . l:command
  execute 'inoremap <silent><special> <Leader>f' . a:char . ' <C-o>' . l:command
endfunction


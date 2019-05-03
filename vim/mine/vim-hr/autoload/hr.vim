" autoload/hr.vim

" Generate a line of a:char from current cursor to end of textwidth
" For &tw=78 (my preferred textwidth) the line will go up to col 78
" http://stackoverflow.com/a/3400528/230473
"
" @param {String} char
function! hr#char(char) abort
  if !strlen(a:char) | return | endif
  let l:tw = getbufvar('%', '&textwidth', 78)
  let l:tw = l:tw ? l:tw : 78
  let l:lastcol = col('$')
  let l:available = l:tw - (l:lastcol - 2)
  let l:available = l:available > 0 ? l:available : 0
  let l:reps = float2nr(floor(l:available / strlen(a:char))) - 1

  " Insert a space if the line is dirty and doesn't already end with
  " whitespace
  let l:is_end_space = match(getline('.')[l:lastcol - 2], '[ \t]') != -1
  if l:lastcol > 1 && !l:is_end_space
    normal! 1A 
    let l:reps -= 1
  endif

  if l:reps <= 0 | return | endif

  " Insert the rule and go to the next line (does not initiate a 3piece
  " comment, but may still insert a new comment character based on
  " formatoptions)
  execute 'normal! ' . l:reps . 'A' . a:char . "\<Esc>o"
endfunction

" Map key
function! hr#map(...) abort
  let l:key = a:1
  let l:command = ':<C-U>call hr#char("' . l:key . '")<CR>'
  execute 'nnoremap <silent><special> <Leader>f' . l:key . ' ' . l:command
  execute 'inoremap <silent><special> <Leader>f' . l:key . ' <C-o>' . l:command
endfunction


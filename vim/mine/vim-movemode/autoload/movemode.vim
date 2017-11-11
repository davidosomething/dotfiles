" autoload/movemode.vim
" Toggle display lines movement mode for normal mode

let s:cpo_save = &cpoptions
set cpoptions&vim

function! movemode#Line() abort
  let b:movementmode = 'linewise'
  echo 'Move by real newlines'
  silent! nunmap <buffer> j
  silent! nunmap <buffer> k
endfunction

" Move by display lines unless a count is given
" https://bluz71.github.io/2017/05/15/vim-tips-tricks.html
function! movemode#Display() abort
  let b:movementmode = 'display'
  echo 'Move by display lines'
  nnoremap <buffer><expr>   j   v:count ? 'j' : 'gj'
  nnoremap <buffer><expr>   k   v:count ? 'k' : 'gk'
endfunction

function! movemode#toggle() abort
  let b:movementmode = get(b:, 'movementmode', 'linewise')
  if b:movementmode     ==? 'linewise' | call movemode#Display()
  elseif b:movementmode ==? 'display'  | call movemode#Line()
  endif
endfunction

let &cpoptions = s:cpo_save
unlet s:cpo_save

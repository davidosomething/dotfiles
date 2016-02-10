" plugin/help.vim
" Help buffer

function! s:Mappings()
  nnoremap <buffer> q :<C-u>close<CR>
  nnoremap <buffer> Q :<C-u>close<CR>
  nnoremap <buffer> <Leader>v :<C-u>wincmd L <BAR> vertical resize 82<CR>

  " opposite of <C-o>
  nnoremap <buffer> o <C-]>

  " STFU
  nnoremap <buffer> a <Nop>
  nnoremap <buffer> c <Nop>
  nnoremap <buffer> d <Nop>
  nnoremap <buffer> i <Nop>
  nnoremap <buffer> m <Nop>
  nnoremap <buffer> p <Nop>
  nnoremap <buffer> r <Nop>
  nnoremap <buffer> s <Nop>
  nnoremap <buffer> u <Nop>
  nnoremap <buffer> x <Nop>
endfunction

augroup dkohelp
  autocmd!
  autocmd BufWinEnter * if &buftype == 'help' | call s:Mappings() | endif
augroup END


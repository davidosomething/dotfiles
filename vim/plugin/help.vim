" plugin/help.vim
" Help buffer

let s:cpo_save = &cpoptions
set cpoptions&vim

function! s:Close()
  if winnr('$') > 1
    :close
  else
    :bprevious
  endif
endfunction

function! s:Mappings()
  nnoremap  <silent><buffer>   q   :<C-u>call <SID>Close()<CR>
  nmap      <silent><buffer>   Q   q

  nnoremap  <silent><buffer>   <Leader>v
        \ :<C-u>wincmd L <BAR> vertical resize 82<CR>

  " Help navigation
  nnoremap <buffer><nowait> < <C-o>
  " opposite of <C-o>
  nnoremap <buffer> o <C-]>
  nnoremap <buffer><nowait> > <C-]>

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
  autocmd BufWinEnter *
        \   if &buftype == 'help' | call s:Mappings() |  endif
augroup END

let &cpoptions = s:cpo_save
unlet s:cpo_save

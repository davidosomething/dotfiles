" plugin/help.vim
" Help buffer

let s:cpo_save = &cpoptions
set cpoptions&vim

" Use vim :help when you press K over a word
setlocal keywordprg=:help

function! s:Close()
  if winnr('$') > 1
    :close
  else
    :bprevious
  endif
endfunction

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
" <nowait> for operator pending or multikeys
noremap <buffer> c <Nop>
noremap <buffer> m <Nop>
noremap <buffer> p <Nop>
noremap <buffer> r <Nop>
noremap <buffer> u <Nop>
noremap <buffer> x <Nop>
noremap <buffer><nowait>  d <Nop>
noremap <buffer><nowait>  s <Nop>
nnoremap <buffer> a <Nop>
nnoremap <buffer> i <Nop>

let &cpoptions = s:cpo_save
unlet s:cpo_save

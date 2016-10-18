" after/ftplugin/help.vim
" Help buffer

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" Don't hide formatting symbols since I write vim helpfiles
" Vim default is conceallevel=2
" ============================================================================

if !&readonly && has('conceal')
  setlocal conceallevel=0
  setlocal concealcursor=

  augroup dkohelp
    autocmd!
  augroup END

  " Toggle vim-hier for help buffers, run :VimhelpLint manually though
  if dko#IsPlugged('vim-vimhelplint') && dko#IsPlugged('vim-hier')
    autocmd dkohelp   BufEnter,BufReadPost  <buffer>   HierStart
    autocmd dkohelp   BufLeave,BufUnload    <buffer>   HierStop
  endif
endif

" ============================================================================
" Use vim :help when you press K over a word
" ============================================================================

setlocal keywordprg=:help

" include dash when looking up keywords, cursor on v in `vim-modes` will
" look up `vim-modes`, not just `vim`
setlocal iskeyword+=-

" ============================================================================
" View-mode mappings
" @TODO extract, used in qf and loclist too
" ============================================================================

function! s:Close()
  if winnr('$') > 1
    :close
  else
    :bprevious
  endif
endfunction

" Only for the actual help buffer, not when editing doc/helpfile.txt
if &buftype ==# 'help'
  nnoremap  <silent><buffer>   q   :<C-U>call <SID>Close()<CR>
  nmap      <silent><buffer>   Q   q

  nnoremap  <silent><buffer>   <Leader>v
        \ :<C-U>wincmd L <BAR> vertical resize 82<CR>

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
endif

let &cpoptions = s:cpo_save
unlet s:cpo_save

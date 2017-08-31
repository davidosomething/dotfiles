" after/plugin/readonly.vim

augroup DKOReadOnly
  autocmd!
augroup END

" ============================================================================
" Read only mode (un)mappings
" ============================================================================

function! s:Close() abort
  if winnr('$') > 1
    :close
  else
    :bprevious
  endif
endfunction

function! s:UnmapForRO() abort
  if !&readonly || !(&buftype ==# 'help' || &buftype ==# 'quickfix')
    return
  endif

  " STFU
  " <nowait> for operator pending or multikeys
  silent! noremap   <buffer>          c <NOP>
  silent! noremap   <buffer>          m <NOP>
  silent! noremap   <buffer>          p <NOP>
  silent! noremap   <buffer>          r <NOP>
  silent! noremap   <buffer>          u <NOP>
  silent! noremap   <buffer>          x <NOP>
  silent! noremap   <buffer><nowait>  d <NOP>
  silent! noremap   <buffer><nowait>  s <NOP>
  silent! nnoremap  <buffer>          a <NOP>
  silent! nnoremap  <buffer>          i <NOP>

  silent! nnoremap <buffer>           <C-j> <NOP>
  silent! nnoremap <buffer>           <C-k> <NOP>
  silent! vnoremap <buffer>           <C-j> <NOP>
  silent! vnoremap <buffer>           <C-k> <NOP>

  silent! nunmap   <buffer>           <leader>c

  " Only for the actual help buffer, not when editing doc/helpfile.txt
  " That's why this is not in the ftplugin
  if &buftype ==# 'help'
    nnoremap  <silent><buffer>            q
          \ :<C-U>call <SID>Close()<CR>
    nmap      <buffer>                    Q
          \ q

    nnoremap  <silent><buffer><special>   <Leader>v
          \ :<C-U>wincmd L <BAR> vertical resize 82<CR>

    " Help navigation
    nnoremap <buffer><nowait>             < <C-o>
    " opposite of <C-o>
    nnoremap <buffer>                     o <C-]>
    nnoremap <buffer><nowait>             > <C-]>
  endif
endfunction

autocmd DKOReadOnly BufEnter,BufReadPost * call s:UnmapForRO()

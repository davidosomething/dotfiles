" after/plugin/readonly.vim

augroup dkoreadonly
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

function! s:Unmap() abort
  if dko#IsEditable()
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

autocmd dkoreadonly BufEnter,BufReadPost * call s:Unmap()

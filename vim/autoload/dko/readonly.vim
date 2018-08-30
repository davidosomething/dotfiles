function! s:Close() abort
  if winnr('$') > 1
    close
  else
    bprevious
  endif
endfunction

function! dko#readonly#Unmap() abort
  if dko#IsEditable('%') | return | endif
  if &buftype !=# 'help' | return | endif

  " Only for the actual help buffer, not when editing doc/helpfile.txt
  " That's why this is not in the ftplugin
  let s:cpo_save = &cpoptions
  set cpoptions&vim

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

  let &cpoptions = s:cpo_save
  unlet s:cpo_save
endfunction

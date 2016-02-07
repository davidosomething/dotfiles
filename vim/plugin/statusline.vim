" plugin/statusline.vim

if !g:dko_use_statusline | finish | endif

function! s:RefreshStatus()
  for l:winnr in range(1, winnr('$'))
    call setwinvar(l:winnr, '&statusline', '%!dkostatus#Output(' . l:winnr . ')')
  endfor
endfunction

augroup status
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * call <SID>RefreshStatus()
augroup END


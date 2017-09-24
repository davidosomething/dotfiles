" plugin/dkoline.vim

augroup plugin-dkoline
  autocmd!
  autocmd VimEnter * call dkoline#Init()
  autocmd VimEnter * call dkoline#HookRefresh()
augroup END

nnoremap <silent><script><special>
      \ <Plug>(dkotabline-refresh)
      \ :<C-U>call dkoline#Refresh()<CR>


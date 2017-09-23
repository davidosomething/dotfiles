" plugin/dkoline.vim

augroup plugin-dkoline
  autocmd!
  autocmd VimEnter * call dkoline#Init()
  autocmd VimEnter * call dkoline#HookRefresh()
augroup END

" plugin/dkoline.vim

augroup plugin-dkoline
  autocmd!
  autocmd VimEnter * call dkoline#Init()
augroup END

" plugin/dkoline.vim

augroup plugin-dkoline
  autocmd!
  autocmd VimEnter * call dkoline#Init()
augroup END

nmap <silent><special>
      \ <Plug>(dkoline-refresh-tabline)
      \ :call dkoline#RefreshTabline()<CR>

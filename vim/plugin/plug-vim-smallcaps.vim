" plugin/plug-vim-smallcaps.vim

if !dkoplug#Exists('vim-smallcaps') | finish | endif

augroup dkovimmovemode
  autocmd!
  autocmd BufEnter * if dko#IsEditable('%')
        \| vmap <special> <Leader>C <Plug>(dkosmallcaps)
        \| endif
augroup END

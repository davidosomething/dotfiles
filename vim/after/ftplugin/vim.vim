" after/ftplugin/vim.vim

setlocal iskeyword-=#

augroup dkoafterftvim
  autocmd!
  autocmd BufWritePost */colors/*.vim
        \ echom 'reload'
        \ | so <afile>
        \ | if dkoplug#plugins#IsLoaded('vim-css-color')
        \ |   call css_color#reinit()
        \ | endif
augroup END

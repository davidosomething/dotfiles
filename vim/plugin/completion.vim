" plugin/completion.vim
" Generic completion helpers.
" See plug-nvim-completion-manager.vim for engine specific settings

augroup dkocompletion
  autocmd!
  autocmd FileType php setlocal omnifunc=
augroup END

" ============================================================================
" Filename completion
" ============================================================================

" useful for filename completion relative to current buffer path
if exists('+autochdir')
  autocmd dkocompletion InsertEnter *
        \   let b:save_cwd = getcwd()
        \ | set autochdir
  autocmd dkocompletion InsertLeave *
        \   set noautochdir
        \ | if exists('b:save_cwd')
        \ |   execute 'cd' fnameescape(b:save_cwd)
        \ | endif
endif

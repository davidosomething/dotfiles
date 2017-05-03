" plugin/plug-tern_for_vim.vim
" tern_for_vim settings
" This plugin is used for its refactoring and helper methods, not completion

if !( dko#IsPlugged('tern_for_vim')
      \&& executable('tern') )
  finish
endif

augroup dkotern
  autocmd!
  autocmd FileType javascript,javascript.jsx nnoremap <silent><buffer> gd :<C-U>TernDef<CR>
augroup END

" Use tabline instead
let g:tern_show_argument_hints = 'no'

" Don't set the omnifunc to tern#Complete
let g:tern_set_omni_function = 0

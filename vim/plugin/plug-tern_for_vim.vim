" plugin/plug-tern_for_vim.vim
" tern_for_vim settings
" This plugin is used for its refactoring and helper methods, not completion

if !( dko#IsLoaded('tern_for_vim') && executable('tern') )
  finish
endif

augroup dkotern
  autocmd!
  autocmd FileType javascript,javascript.jsx nnoremap <silent><buffer> gd :<C-U>TernDef<CR>
augroup END

" Settings common to deoplete-ternjs (vim var read via python) and
" tern_for_vim
" @see https://github.com/carlitux/deoplete-ternjs/blob/5500ae246aa1421a0e578c2c7e1b00d858b2fab2/rplugin/python3/deoplete/sources/ternjs.py#L70-L75
let g:tern_request_timeout       = 1 " undocumented in tern_for_vim
let g:tern_show_signature_in_pum = 1

" Use tabline instead
let g:tern_show_argument_hints = 'no'

" Don't set the omnifunc to tern#Complete
let g:tern_set_omni_function = 0

" Open loclist when doing search for refs
let g:tern_show_loc_after_refs = 1

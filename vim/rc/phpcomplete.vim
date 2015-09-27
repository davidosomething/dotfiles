" mapping conflict with vim-rails, change <C-]> to <C-)>
let g:phpcomplete_enhance_jump_to_definition = 0
let g:phpcomplete_parse_docblock_comments = 1

" from neocomplete docs -- phpcomplete.vim integration
" word head ignored so can restart completion
" @see <https://github.com/Shougo/neocomplete.vim/issues/33#issuecomment-20732229>
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.php =
      \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'


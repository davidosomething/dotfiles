" ftplugin/php.vim
"
" Vars that need to be set early
"

" PHP indent settings for distributed $VIMRUNTIME/indent/php.vim
let g:PHP_outdentphpescape = 0

" ============================================================================
" phpcomplete.vim
" ============================================================================
if exists("g:plugs['phpcomplete.vim']")
  let g:phpcomplete_parse_docblock_comments = 1
endif


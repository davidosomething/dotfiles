" ============================================================================
" PHP-Indenting-for-VIm.vim
" ============================================================================

let g:PHP_outdentphpescape = 0

" ============================================================================
" StanAngeloff/php.vim
" ============================================================================

function! g:PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call g:PhpSyntaxOverride()
augroup END

" ============================================================================
" phpcomplete.vim
" ============================================================================

" mapping conflict with vim-rails, change <C-]> to <C-)>
let g:phpcomplete_enhance_jump_to_definition = 0
let g:phpcomplete_parse_docblock_comments = 1

" ============================================================================
" pdv.vim
" ============================================================================

let g:pdv_template_dir = expand(g:dko_vim_dir . g:dko_plugdir . '/pdv/templates')

autocmd vimrc FileType php
      \ nnoremap <buffer> <silent> <Leader>pd :call pdv#DocumentCurrentLine()<CR>


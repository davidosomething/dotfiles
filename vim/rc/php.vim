" ============================================================================
" PHP-Indenting-for-VIm.vim
" ============================================================================

" The plugin expects this var to be set before it loads and doesn't read it
" again afterwards, so we update it again for the buffer
autocmd vimrc FileType php
      \ let b:PHP_outdentphpescape = 0

" ============================================================================
" StanAngeloff/php.vim
" ============================================================================

" Syntax highlighting in phpdoc blocks
function! g:PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction
autocmd vimrc FileType php
      \ call g:PhpSyntaxOverride()

" ============================================================================
" phpcomplete.vim
" ============================================================================

let g:phpcomplete_parse_docblock_comments = 1

" ============================================================================
" pdv.vim
" ============================================================================

let g:pdv_template_dir =
      \ expand(g:dko_vim_dir . g:dko_plugdir . '/pdv/templates')

autocmd vimrc FileType php
      \ nnoremap <buffer> <silent>
      \   <Leader>pd :call pdv#DocumentCurrentLine()<CR>


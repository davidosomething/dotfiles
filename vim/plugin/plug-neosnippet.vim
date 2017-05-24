" plugin/plug-neosnippet.vim

if !dko#IsLoaded('neosnippet') | finish | endif
let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

" Snippets userdir
let g:neosnippet#snippets_directory = g:dko#vim_dir . '/snippets'

let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#enable_conceal_markers = 0

" The javascript.* set is included via 'javascript' but mocha is a separate
" filetype
" Using my own vim/snippets/dko-javascript-mocha instead of honza's
let g:neosnippet#scope_aliases = {}
let g:neosnippet#scope_aliases['javascript'] = join([
      \   'javascript',
      \   'dko-javascript-mocha',
      \ ], ',')

" Keybindings for snippet completion
" Pressing <TAB> with PUM open will move through results, but won't expand
" unless I explicitly hit <C-f>
silent! iunmap <C-f>
silent! sunmap <C-f>
silent! xunmap <C-f>
imap  <special>   <C-f>   <Plug>(neosnippet_expand_or_jump)
smap  <special>   <C-f>   <Plug>(neosnippet_expand_or_jump)
xmap  <special>   <C-f>   <Plug>(neosnippet_expand_target)

" Get rid of the placeholders in inserted snippets when done inserting
augroup dkoneosnippet
  autocmd!
  autocmd InsertLeave * NeoSnippetClearMarkers
augroup END

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

" plugin/plug-neosnippet.vim

if !dkoplug#IsLoaded('neosnippet') | finish | endif

augroup dkoneosnippet
  autocmd!
  " Get rid of the placeholders in inserted snippets when done inserting
  autocmd dkoneosnippet InsertLeave * NeoSnippetClearMarkers
augroup END

" ============================================================================
" Settings
" ============================================================================

" Snippets userdir
let g:neosnippet#snippets_directory = g:dko#vim_dir . '/snippets'
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#enable_conceal_markers = 0
let g:neosnippet#scope_aliases = {}
let g:neosnippet#scope_aliases['javascript'] = join([
      \   'javascript',
      \   'javascript.es6.react',
      \ ], ',')

" ============================================================================
" Mappings
" ============================================================================

let s:cpo_save = &cpoptions
set cpoptions&vim

" Keybindings for snippet completion
" Pressing <TAB> with PUM open will move through results, but won't expand
" unless I explicitly hit <C-f>
silent! iunmap <C-f>
silent! sunmap <C-f>
silent! xunmap <C-f>
imap  <special>   <C-f>   <Plug>(neosnippet_expand_or_jump)
smap  <special>   <C-f>   <Plug>(neosnippet_expand_or_jump)
xmap  <special>   <C-f>   <Plug>(neosnippet_expand_target)

" Insert phpdoc block
nnoremap <silent><special>
      \ <Leader>pd
      \ O<Esc>a<C-r>=neosnippet#expand('doc')<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save

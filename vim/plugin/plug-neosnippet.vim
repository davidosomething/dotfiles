" plugin/plug-neosnippet.vim

augroup dkoneosnippet
  autocmd!
augroup END

if !dkoplug#IsLoaded('neosnippet')
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

if dkoplug#IsLoaded('neosnippet')
  let g:neosnippet#snippets_directory = g:dko#vim_dir . '/snippets'
  let g:neosnippet#enable_snipmate_compatibility = 1
  let g:neosnippet#enable_conceal_markers = 0
  let g:neosnippet#scope_aliases = {}
  let g:neosnippet#scope_aliases['javascript'] = join([
        \   'javascript',
        \   'javascript.jsx',
        \   'javascript.es6.react',
        \ ], ',')

  " Get rid of the placeholders in inserted snippets when done inserting
  autocmd dkocompletion InsertLeave * NeoSnippetClearMarkers

  silent! iunmap <C-f>
  silent! sunmap <C-f>
  silent! xunmap <C-f>

  " Insert js/phpdoc block
  nnoremap <silent><special>
        \ <Leader>pd
        \ O<Esc>a<C-r>=neosnippet#expand('doc')<CR>

  " Keybindings for snippet completion
  imap  <C-f>   <Plug>(neosnippet_expand_or_jump)
  smap  <C-f>   <Plug>(neosnippet_expand_or_jump)
  xmap  <C-f>   <Plug>(neosnippet_expand_target)
endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save


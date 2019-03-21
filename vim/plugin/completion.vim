" plugin/completion.vim

augroup dkocompletion
  autocmd!
augroup END

if !dkoplug#IsLoaded('coc.nvim') && !dkoplug#IsLoaded('neosnippet')
  finish
endif

if dkoplug#IsLoaded('coc.nvim')
  let g:coc_enable_locationlist = 0
  let g:coc_snippet_next = '<C-f>'
  let g:coc_snippet_prev = '<C-b>'

  function! s:ShowDocumentation()
    if &filetype ==# 'vim'
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
endif

if dkoplug#IsLoaded('neosnippet')
  let g:neosnippet#snippets_directory = g:dko#vim_dir . '/snippets'
  let g:neosnippet#enable_snipmate_compatibility = 1
  let g:neosnippet#enable_conceal_markers = 0
  let g:neosnippet#scope_aliases = {}
  let g:neosnippet#scope_aliases['javascript'] = join([
        \   'javascript',
        \   'javascript.es6.react',
        \ ], ',')

  " Get rid of the placeholders in inserted snippets when done inserting
  autocmd dkocompletion InsertLeave * NeoSnippetClearMarkers
endif

" ============================================================================
" Mappings
" ============================================================================

let s:cpo_save = &cpoptions
set cpoptions&vim

if dkoplug#IsLoaded('neosnippet')
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

if dkoplug#IsLoaded('coc.nvim')
  nmap <silent> <Leader>d <Plug>(coc-diagnostic-info)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)
  nmap <silent> [d <Plug>(coc-diagnostic-prev)
  nmap <silent> gh <Plug>(coc-declaration)
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nnoremap <silent> K :<C-U>call <SID>ShowDocumentation()<CR>
endif

let &cpoptions = s:cpo_save
unlet s:cpo_save

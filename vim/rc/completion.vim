" ============================================================================
" Omni-completion by filetype
" ============================================================================

autocmd vimrc FileType css           setlocal omnifunc=csscomplete#CompleteCSS
autocmd vimrc FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags

" may be later overridden for tern
autocmd vimrc FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS

" built-in, also phpcomplete-extended provides support
" @see <https://github.com/shawncplus/phpcomplete.vim/issues/55#issuecomment-72163856>
"autocmd vimrc FileType php setlocal omnifunc=phpcomplete#CompletePHP

autocmd vimrc FileType python        setlocal omnifunc=pythoncomplete#Complete
autocmd vimrc FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
autocmd vimrc FileType ruby          setlocal omnifunc=rubycomplete#Complete

" ============================================================================
" Neosnippet
" ============================================================================

imap <C-k>        <Plug>(neosnippet_expand_or_jump)
smap <C-k>        <Plug>(neosnippet_expand_or_jump)
xmap <C-k>        <Plug>(neosnippet_expand_target)
smap <expr><Tab>  neosnippet#expandable_or_jumpable()
      \ ? "\<Plug>(neosnippet_expand_or_jump)"
      \ : "\<Tab>"

" ============================================================================
" Shougo completion
" ============================================================================

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0

" from the github page: <CR> cancels completion and inserts newline
function! s:my_cr_function()
  " v2.1
  "return deoplete#close_popup() . "\<CR>"

  " v next
  return (pumvisible() ? "\<C-y>" : "") . "\<CR>"
  "return pumvisible() ? "\<C-y>" : "\<CR>"
  "return "\<C-y>\<CR>"
endfunction
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>

" ============================================================================
" Shougo + IndentTab interaction
" ============================================================================
if g:dko_use_indenttab
  " select completion using tab
  let g:IndentTab_IsSuperTab = 1
  inoremap <expr><Tab>   pumvisible()
        \ ? "\<C-n>"
        \ : IndentTab#Tab()
  "\<TAB>"
  inoremap <expr><S-Tab> pumvisible()
        \ ? "\<C-p>"
        \ : "\<S-Tab>"
endif

" ============================================================================
" Neocomplete
" ============================================================================

if g:dko_use_neocomplete
  let g:neocomplete#enable_at_startup            = 1
  let g:neocomplete#enable_smart_case            = 1
  let g:neocomplete#enable_camel_case            = 1
  let g:neocomplete#enable_fuzzy_completion      = 0
  let g:neocomplete#data_directory = expand(g:dko_vim_dir . '/.cache/neocomplete')

  " completion sources
  let g:neocomplete#sources#syntax#min_keyword_length = 3

  if !exists('g:neocomplete#sources#omni#functions')
    let g:neocomplete#sources#omni#functions = {}
  endif

  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif

  let g:neocomplete#sources#omni#input_patterns.typescript =
        \ '[^. \t]\.\%(\h\w*\)\?'

  " re-open completion with c-space
  " @see <https://github.com/Shougo/neocomplete.vim/issues/33#issuecomment-20732569>
  inoremap <expr><C-Space>        neocomplete#start_manual_complete('omni')
endif

" ============================================================================
" Deoplete
" ============================================================================

if g:dko_use_deoplete
  let g:deoplete#enable_at_startup            = 1
  let g:deoplete#auto_completion_start_length = 3

  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
  endif

  let g:deoplete#sources#omni#input_patterns.typescript =
        \ '[^. \t]\.\%(\h\w*\)\?'

  " re-open completion with c-space
  " @see <https://github.com/Shougo/deoplete.vim/issues/33#issuecomment-20732569>
  inoremap <expr><C-Space>        deoplete#start_manual_complete('omni')
endif

" ============================================================================
" tern
" ============================================================================
if g:dko_use_tern_completion

  autocmd vimrc FileType javascript setl omnifunc=tern#Complete

  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1

  " ============================================================================
  " neocomplete tern integration
  " ============================================================================
  if g:dko_use_neocomplete
    " See vice setup for stuff to steal
    " @see <https://github.com/zeekay/vice-neocompletion/blob/master/autoload/vice/neocomplete.vim>

    " JavaScript -----------------------------------------------------------------
    let g:neocomplete#sources#omni#functions.javascript = 'tern#Complete'
    let g:neocomplete#sources#omni#input_patterns.javascript = '\h\w*\|[^. \t]\.\w*'

    " CoffeeScript ---------------------------------------------------------------
    let g:neocomplete#sources#omni#functions.coffee = 'tern#Complete'
    let g:neocomplete#sources#omni#input_patterns.coffee = '\h\w*\|[^. \t]\.\w*'

    " TypeScript -----------------------------------------------------------------
    let g:neocomplete#sources#omni#functions.typescript = 'tern#Complete'
  endif
endif


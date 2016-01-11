if !g:dko_has_completion | finish | endif

" ============================================================================
" Special keys in PUM
" ============================================================================

" This does the work of IndentTab#SuperTabIntegration#GetExpr() with the other
" plugins in consideration
" Tab advances selection or inserts tab
function! s:DKO_NextFieldOrTab()
  " Advance and select autocomplete result
  if pumvisible()
    return "\<C-n>"

  " Insert a real tab using IndentTab
  elseif exists('g:plugs["IndentTab"]')
    return IndentTab#Tab()

  endif

  " Insert a real tab -- only if there's no IndentTab
  return "\<Tab>"
endfunction
" IndentTab requires noremap!
inoremap  <silent><expr>  <Tab>     <SID>DKO_NextFieldOrTab()

" S-Tab goes reverses selection or untabs
function! s:DKO_ReverseOrUntab()
  return pumvisible() ? "\<C-p>" : "\<C-d>"
endfunction
imap      <silent><expr>  <S-Tab>   <SID>DKO_ReverseOrUntab()

" CR accepts selection AND enter a real <CR>
function! s:DKO_AcceptAndCr()
  return pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
endfunction

" https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1559
inoremap  <silent><expr>  <CR>      <SID>DKO_AcceptAndCr()

" ============================================================================
" Omni-completion by filetype
" ============================================================================

" We keep this here and not in filetype related sections since some files,
" like HTML, Markdown, and PHP, have mixed languages in them.
" These are the default omnifuncs. Neocomplete may use something entirely
" different if there are other sources available (e.g. TernJS for JavaScript)
augroup dkoomnifuncs
  autocmd!
  autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS

  " built-in, also phpcomplete-extended provides support
  " @see <https://github.com/shawncplus/phpcomplete.vim/issues/55#issuecomment-72163856>
  "autocmd vimrc FileType php setlocal omnifunc=phpcomplete#CompletePHP

  autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
  autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

" ============================================================================
" Neosnippet
" ============================================================================

if exists('g:plugs["neosnippet"]')
  " Snippets userdir
  let g:neosnippet#snippets_directory = g:dko_vim_dir . '/snippets'

  " C-k is the only acceptable neosnippet advance key
  imap  <C-k>   <Plug>(neosnippet_jump_or_expand)
  smap  <C-k>   <Plug>(neosnippet_jump_or_expand)
  xmap  <C-k>   <Plug>(neosnippet_expand_target)
endif

" ============================================================================
" Neocomplete
" ============================================================================

if exists('g:plugs["neocomplete.vim"]')
  let g:neocomplete#enable_at_startup            = 1
  let g:neocomplete#enable_smart_case            = 1
  let g:neocomplete#enable_camel_case            = 1
  let g:neocomplete#data_directory =
        \ expand(g:dko_vim_dir . '/.tmp/neocomplete')

  " Match by string head instead of fuzzy
  let g:neocomplete#enable_fuzzy_completion      = 0
  call neocomplete#custom#source('_', 'matchers', [
        \   'matcher_head',
        \   'matcher_length',
        \ ])

  " --------------------------------------------------------------------------
  " Completion sources
  " --------------------------------------------------------------------------

  let g:neocomplete#sources#syntax#min_keyword_length = 3

  " Custom source references
  if !exists('g:neocomplete#sources#vim#complete_functions')
    let g:neocomplete#sources#vim#complete_functions = {}
  endif

  " omnifunc to use by language
  if !exists('g:neocomplete#sources#omni#functions')
    let g:neocomplete#sources#omni#functions = {}
  endif

  " Regex to match typed chars on by language
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif

  " --------------------------------------------------------------------------
  " JavaScript
  " --------------------------------------------------------------------------

  let g:neocomplete#sources#omni#functions.javascript = [
        \   'javascriptcomplete#CompleteJS',
        \ ]
  let g:neocomplete#sources#omni#input_patterns.javascript =
        \ '\h\w*\|[^. \t]\.\w*'

  " --------------------------------------------------------------------------
  " CoffeeScript
  " --------------------------------------------------------------------------

  let g:neocomplete#sources#omni#functions.coffee = [
        \   'javascriptcomplete#CompleteJS',
        \ ]
  let g:neocomplete#sources#omni#input_patterns.coffee =
        \ '\h\w*\|[^. \t]\.\w*'

  " --------------------------------------------------------------------------
  " TypeScript
  " --------------------------------------------------------------------------

  " @TODO clausreinke/typescript-tools
  " @TODO Quramy/tsuquyomi
  let g:neocomplete#sources#omni#functions.typescript = []

  let g:neocomplete#sources#omni#input_patterns.typescript =
        \ '[^. \t]\.\%(\h\w*\)\?'
endif

" ============================================================================
" Deoplete
" ============================================================================

if exists('g:plugs["deoplete.nvim"]')
  let g:deoplete#enable_at_startup            = 1
  let g:deoplete#auto_completion_start_length = 3

  if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
  endif

  let g:deoplete#omni#input_patterns.typescript =
        \ '[^. \t]\.\%(\h\w*\)\?'
endif

" ============================================================================
" vim-better-javascript-completion
" ============================================================================

if exists('g:plugs["vim-better-javascript-completion"]')

  " ============================================================================
  " neocomplete 1995eaton integration
  " ============================================================================

  if exists('g:plugs["neocomplete.vim"]')
    call insert(g:neocomplete#sources#omni#functions.javascript, 'js#CompleteJS')
  endif

endif

" ============================================================================
" tern
" ============================================================================

if exists('g:plugs["tern_for_vim"]')

  " Change default javascript completion to use just TernJS
  "autocmd vimrc FileType javascript setl omnifunc=tern#Complete

  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1

  augroup dkotern
    autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>
  augroup END

  " ============================================================================
  " neocomplete tern integration
  " ============================================================================

  if exists('g:plugs["neocomplete.vim"]')
    " See vice setup for stuff to steal
    " @see <https://github.com/zeekay/vice-neocompletion/blob/master/autoload/vice/neocomplete.vim>

    " " Prepend tern to sources list for each lang
    call insert(g:neocomplete#sources#omni#functions.javascript,  'tern#Complete')
    call insert(g:neocomplete#sources#omni#functions.javascript,  'tern#Complete')
    call insert(g:neocomplete#sources#omni#functions.coffee,      'tern#Complete')
    call insert(g:neocomplete#sources#omni#functions.typescript,  'tern#Complete')

  endif
endif


" ============================================================================
" Omni-completion by filetype
" ============================================================================

augroup vimrc
  autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags

  " may be later overridden for tern
  autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS

  " built-in, also phpcomplete-extended provides support
  " @see <https://github.com/shawncplus/phpcomplete.vim/issues/55#issuecomment-72163856>
  "autocmd vimrc FileType php setlocal omnifunc=phpcomplete#CompletePHP

  autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType ruby          setlocal omnifunc=rubycomplete#Complete
augroup end

" ============================================================================
" Neosnippet
" ============================================================================

" Snippets userdir
let g:neosnippet#snippets_directory = g:dko_vim_dir . '/snippets'

imap  <C-k>   <Plug>(neosnippet_jump_or_expand)
smap  <C-k>   <Plug>(neosnippet_jump_or_expand)
xmap  <C-k>   <Plug>(neosnippet_expand_target)

" Select mode
smap  <expr><Tab>  neosnippet#expandable_or_jumpable()
      \ ? "\<Plug>(neosnippet_jump_or_expand)"
      \ : "\<Tab>"

" ============================================================================
" <CR> setup for pum
" ============================================================================

function! s:DKO_CR()
  " Close popup and enter a real <CR>
  return (pumvisible() ? "\<C-y>" : "") . "\<CR>"
endfunction
inoremap <silent> <CR> <C-r>=<SID>DKO_CR()<CR>

" ============================================================================
" <Tab> setup for neosnippet + IndentTab + pum completion
" ============================================================================

" This does the work of IndentTab#SuperTabIntegration#GetExpr() with the other
" plugins in consideration
function! s:DKO_NextFieldOrTab()
  " Next autocomplete result
  if pumvisible()
    return "\<C-n>"

  " In a neosnippet, jump to field
  elseif neosnippet#expandable_or_jumpable()
    return "\<Plug>(neosnippet_jump_or_expand)"

  " Insert a real tab using IndentTab
  elseif exists('g:plugs["IndentTab"]')
    return IndentTab#Tab()

  endif

  " Insert a real tab -- only if there's no IndentTab
  return "\<Tab>"
endfunction

" make sure to use noremap here or else indenttab fails
inoremap  <expr><Tab>     <SID>DKO_NextFieldOrTab()

inoremap  <expr><S-Tab>   pumvisible()
      \ ? "\<C-p>"
      \ : "\<C-d>"

" ============================================================================
" Neocomplete
" ============================================================================

if exists('g:plugs["neocomplete.vim"]')
  let g:neocomplete#enable_at_startup            = 1
  let g:neocomplete#enable_smart_case            = 1
  let g:neocomplete#enable_camel_case            = 1
  let g:neocomplete#enable_fuzzy_completion      = 0
  let g:neocomplete#data_directory =
        \ expand(g:dko_vim_dir . '/.cache/neocomplete')

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
" tern
" ============================================================================
if exists('g:plugs["tern_for_vim"]')

  autocmd vimrc FileType javascript setl omnifunc=tern#Complete

  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1

  " ============================================================================
  " neocomplete tern integration
  " ============================================================================
  if exists('g:plugs["neocomplete.vim"]')
    " See vice setup for stuff to steal
    " @see <https://github.com/zeekay/vice-neocompletion/blob/master/autoload/vice/neocomplete.vim>

    " JavaScript -----------------------------------------------------------------
    let g:neocomplete#sources#omni#functions.javascript = 'tern#Complete'
    let g:neocomplete#sources#omni#input_patterns.javascript =
          \ '\h\w*\|[^. \t]\.\w*'

    " CoffeeScript ---------------------------------------------------------------
    let g:neocomplete#sources#omni#functions.coffee = 'tern#Complete'
    let g:neocomplete#sources#omni#input_patterns.coffee =
          \ '\h\w*\|[^. \t]\.\w*'

    " TypeScript -----------------------------------------------------------------
    let g:neocomplete#sources#omni#functions.typescript = 'tern#Complete'
  endif
endif


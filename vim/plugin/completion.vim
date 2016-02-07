" See vice setup for stuff to steal
" @see <https://github.com/zeekay/vice-neocompletion/blob/master/autoload/vice/neocomplete.vim>

if !g:dko_has_completion | finish | endif

" ============================================================================
" Default bundled omni-completion for each filetype
" ============================================================================

" Global is using syntaxcomplete
" We keep this here and not in filetype related sections since some files,
" like HTML, Markdown, and PHP, have mixed languages in them.
" These set the default omnifuncs. Completion engine will use something
" different if there are other sources available (e.g. TernJS for JavaScript).
augroup dkoomnifuncs
  autocmd!
  autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType php           setlocal omnifunc=phpcomplete#CompletePHP
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
" Neocomplete / Deoplete
" ============================================================================

let s:use_phpcomplete = 0

" When defined for a filetype, call the omnifunc directly (feedkeys
" <C-X><C-O>) instead of delegating to completion plugin. See each plugin
" section for settings.
" neocomplete dict: g:neocomplete#force_omni_input_patterns
" deoplete dict:    g:deoplete#omni_patterns
" - string vim regex
let s:fip = {}

" c-type with clang_complete -- not used but correct
" let s:fip.c =       '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?',
" let s:fip.cpp =     '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?',
" let s:fip.objc =    '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
" let s:fip.objcpp =  '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'

" ruby with Shougo/neocomplete-rsense -- not used but correct
" https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1605
" let s:fip.ruby = '[^. *\t]\.\w*\|\h\w*::'

" python with davidhalter/jedi-vim -- not used but correct
" https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1617
" let s:fip.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

" typescript with Quramy/tsuquyomi -- not used but correct
" let s:fip.typescript = '[^. \t]\.\%(\h\w*\)\?'
" let s:fip.typescript = '\h\w*\|[^. \t]\.\w*' -- maybe more relaxed

" ----------------------------------------------------------------------------
" Omnifunc for each filetype
" ----------------------------------------------------------------------------

" When triggering a completion within an engine, use these omnifuncs
" deoplete    g:deoplete#omni#functions
" neocomplete g:neocomplete#sources#omni#functions
" - list of omnifunc function names
let s:omnifuncs = {}

" JavaScript (probably superseded by tern)
let s:omnifuncs.javascript = [ 'javascriptcomplete#CompleteJS' ]

" PHP
let s:omnifuncs.php = [ 'phpcomplete#CompletePHP' ]

" ============================================================================
" Completion Plugin: jspc.vim
" ============================================================================

if 1 && exists('g:plugs["jspc.vim"]')
  let s:indexdefault = index(s:omnifuncs.javascript, 'javascriptcomplete#CompleteJS')
  " jspc.vim wraps the default omnicomplete, so we'll have duplicates if we
  " have both in our neocomplete sources.
  " Remove last item, which is 'javascriptcomplete#CompleteJS'
  call remove(s:omnifuncs.javascript, s:indexdefault)
  call add(s:omnifuncs.javascript, 'jspc#omni')
endif

" ============================================================================
" Completion Plugin: vim-better-javascript-completion
" ============================================================================

if 1 && exists('g:plugs["vim-better-javascript-completion"]')
  " insert instead of add, this is preferred completion omnifunc (except tern)
  call insert(s:omnifuncs.javascript, 'js#CompleteJS')
endif

" ============================================================================
" Completion Plugin: tern
" This overrides all other JS completions
" ============================================================================

if 1 && exists('g:plugs["tern_for_vim"]')
  "let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1

  augroup dkoomnifuncs
    autocmd FileType javascript nnoremap <silent><buffer> gb :TernDef<CR>
    autocmd FileType javascript setlocal omnifunc=tern#Complete
  augroup END

  " force using omnicompletion (tern in this case)
  " pretty much match anything | match whitespace and then anything
  "let s:fip.javascript = '\h\w*\|[^. \t]\.\w*'
  let s:fip.javascript = '[^. \t]\.\w*'
endif

" ============================================================================
" Completion Plugin: phpcomplete.vim
" ============================================================================

if 1 && s:use_phpcomplete && exists("g:plugs['phpcomplete.vim']")
  let g:phpcomplete_parse_docblock_comments = 1
endif

" ============================================================================
" Completion Plugin: phpcomplete-extended
" ============================================================================

if 1 && s:use_phpcomplete && exists("g:plugs['phpcomplete-extended']")
  call insert(s:omnifuncs.php, 'phpcomplete_extended#CompletePHP' )
endif

" ============================================================================
" Neocomplete
" ============================================================================

if exists('g:plugs["neocomplete.vim"]')
  let g:neocomplete#data_directory =
        \ expand(g:dko_vim_dir . '/.tmp/neocomplete')

  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#enable_camel_case = 1

  " no effect since i completeopt-=preview
  let g:neocomplete#enable_auto_close_preview = 1

  " Match by string head instead of fuzzy
  let g:neocomplete#enable_fuzzy_completion = 0
  call neocomplete#custom#source('_', 'matchers', [
        \   'matcher_head',
        \   'matcher_length',
        \ ])

  " --------------------------------------------------------------------------
  " Sources for engine-based omni-completion (ignored if match s:fip)
  " --------------------------------------------------------------------------

  call dko#InitObject('g:neocomplete#sources#omni#functions')
  call extend(g:neocomplete#sources#omni#functions, s:omnifuncs)

  " --------------------------------------------------------------------------
  " Input patterns
  " --------------------------------------------------------------------------

  " Patterns that bypass to &omnifunc
  call dko#InitObject('g:neocomplete#force_omni_input_patterns')
  call extend(g:neocomplete#force_omni_input_patterns, s:fip)

  " Completion engine input patterns
  " - String or list of vim regex
  let s:neo_patterns = {}

  " coffee
  "let s:neo_patterns.coffee = '\h\w*\|[^. \t]\.\w*'

  " javascript (superseded by s:fip when tern is available)
  " default: https://github.com/Shougo/neocomplete.vim/blame/34b42e76be30c0f365110ea036c8490b38fcb13e/autoload/neocomplete/sources/omni.vim
  let s:neo_patterns.javascript = '\h\w*\|[^. \t]\.\w*'

  " lua with xolox/vim-lua-ftplugin -- not used but correct
  " https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1705
  " let s:neo_patterns.lua = '\w\+[.:]\|require\s*(\?["'']\w*'

  " perl
  "let s:neo_patterns.perl   = '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

  " php with phpcomplete.vim support
  " https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1731
  if s:use_phpcomplete
    let s:neo_patterns.php =
          \ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
  endif

  call dko#InitObject('g:neocomplete#sources#omni#input_patterns')
  call extend(g:neocomplete#sources#omni#input_patterns, s:neo_patterns)
endif

" ============================================================================
" Deoplete
" ============================================================================

if exists('g:plugs["deoplete.nvim"]')
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#auto_completion_start_length = 1
  call deoplete#custom#set('_', 'matchers', [
        \   'matcher_head',
        \   'matcher_length',
        \ ])

  " --------------------------------------------------------------------------
  " Sources for engine based omni-completion (ignored if match s:fip)
  " Unlike neocomplete, deoplete only supports one omnifunction at a time
  " --------------------------------------------------------------------------

  call dko#InitObject('g:deoplete#omni#functions')
  " Not extending, instead pluck first item from list since deoplete only
  " supports one omnifunc
  call extend(g:deoplete#omni#functions, map(copy(s:omnifuncs), 'v:val[0]'))

  " --------------------------------------------------------------------------
  " Input patterns
  " --------------------------------------------------------------------------

  " Patterns that bypass to &omnifunc
  call dko#InitObject('g:deoplete#omni_patterns')
  call extend(g:deoplete#omni_patterns, s:fip)

  " Completion engine input patterns
  " - Python 3 regex
  let s:deo_patterns = {}
  " not quite...
  " if s:is_php_enabled
  "   let s:deo_patterns.php = [
  "         \   '[^. \t0-9]\.\w*',
  "         \   '[^. \t0-9]\->\w*',
  "         \   '[a-zA-Z_]\::\w*',
  "         \ ]
  " endif
  call dko#InitObject('g:deoplete#omni#input#patterns')
  call extend(g:deoplete#omni#input#patterns, s:deo_patterns)

endif

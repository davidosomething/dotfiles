" plugin/completion.vim
"
" See vice setup for stuff to steal
" @see <https://github.com/zeekay/vice-neocompletion/blob/master/autoload/vice/neocomplete.vim>
"

if !g:dko_has_completion | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" Default bundled omni-completion for each filetype
" ============================================================================

" These set the default omnifuncs. Completion engine will use something
" different if there are other sources available (e.g. TernJS for JavaScript).
augroup dkocompletion
  autocmd!
  autocmd FileType css
        \ setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown
        \ setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript
        \ setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType php
        \ setlocal omnifunc=phpcomplete#CompletePHP
  autocmd FileType python
        \ setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType ruby
        \ setlocal omnifunc=rubycomplete#Complete
  autocmd FileType xml
        \ setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

" ============================================================================
" Neosnippet
" ============================================================================

if exists('g:plugs["neosnippet"]')
  " Snippets userdir
  let g:neosnippet#snippets_directory = g:dko_vim_dir . '/snippets'

  " C-k is the only acceptable neosnippet advance key
  imap  <special> <C-k>   <Plug>(neosnippet_jump_or_expand)
  smap  <special> <C-k>   <Plug>(neosnippet_jump_or_expand)
  xmap  <special> <C-k>   <Plug>(neosnippet_expand_target)
endif

" ============================================================================
" Neocomplete / Deoplete
" ============================================================================

let s:REGEXPS = {}
let s:REGEXPS.any_word        = '\h\w*'
let s:REGEXPS.nonspace_dot    = '[^-. \t]\.\w*'
let s:REGEXPS.nonspace_arrow  = '[^-. \t]->\w*'
let s:REGEXPS.word_scope_word = '\h\w*::\w*'

" For jspc.vim
let s:REGEXPS.keychar   = '\k\zs \+'
let s:REGEXPS.parameter = s:REGEXPS.keychar . '\|' . '(' . '\|' . ':'

" ----------------------------------------------------------------------------
" Regexes to use completion engine
" See plugins sections too (e.g. phpcomplete and jspc)
" ----------------------------------------------------------------------------

" Neocomplete
" - String or list of vim regex
let s:neo_patterns = {}

" coffee
"let s:neo_patterns.coffee = '\h\w*\|[^. \t]\.\w*'

" javascript
" default: https://github.com/Shougo/neocomplete.vim/blame/34b42e76be30c0f365110ea036c8490b38fcb13e/autoload/neocomplete/sources/omni.vim
let s:neo_patterns.javascript =
      \ s:REGEXPS.any_word
      \ . '\|' . s:REGEXPS.nonspace_dot

" lua with xolox/vim-lua-ftplugin -- not used but correct
" https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1705
" let s:neo_patterns.lua = '\w\+[.:]\|require\s*(\?["'']\w*'

" perl
"let s:neo_patterns.perl   = '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

"Deoplete
" - Python 3 regex
let s:deo_patterns = {}

" ----------------------------------------------------------------------------
" Regexes to force omnifunc completion
" See plugins sections too (e.g. tern)
" ----------------------------------------------------------------------------

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
" Completion Plugin: vim-better-javascript-completion
" ============================================================================

if exists('g:plugs["vim-better-javascript-completion"]')
  " insert instead of add, this is preferred completion omnifunc (except tern)
  call insert(s:omnifuncs.javascript, 'js#CompleteJS')
endif

" ============================================================================
" Completion Plugin: tern
" This overrides all other JS completions when fip matches
" ============================================================================

if g:dko_use_tern_completion
  "let g:tern_show_argument_hints = 'on_hold'   " Use tabline instead (<F10>)
  let g:tern_show_signature_in_pum = 1

  augroup dkocompletion
    autocmd FileType javascript nnoremap <silent><buffer> gb :<C-u>TernDef<CR>
    " Set omnifunc every time, in case jspc's after ftplugin call to init
    " sets it to jspc#omni
    autocmd FileType javascript setlocal omnifunc=tern#Complete
  augroup END

  " force using tern when typing matches regex
  " first regex is match 5 or more characters to end of line
  "let s:fip.javascript = '\h\k\{4,}$' . '\|' .
  let s:fip.javascript = s:REGEXPS.nonspace_dot
endif

" ============================================================================
" Completion Plugin: jspc.vim
" <C-x><c-u> to use jspc in particular
" ============================================================================

if exists('g:plugs["jspc.vim"]')
  autocmd dkocompletion FileType javascript setlocal completefunc=jspc#omni
  " jspc.vim wraps the default omnicomplete, so we'll have duplicates if we
  " have both in our neocomplete sources.
  call remove(
        \   s:omnifuncs.javascript,
        \   index(s:omnifuncs.javascript, 'javascriptcomplete#CompleteJS')
        \ )
  call add(s:omnifuncs.javascript, 'jspc#omni')
endif

" ============================================================================
" Completion Plugin: phpcomplete.vim
" don't need to check exists since an older one comes with vimruntime
" ============================================================================

if exists("g:plugs['phpcomplete.vim']")
  let g:phpcomplete_parse_docblock_comments = 1

  " php with phpcomplete.vim support
  " https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1731
  let s:neo_patterns.php =
      \ s:REGEXPS.any_word
      \ . '\|' . s:REGEXPS.nonspace_arrow
      \ . '\|' . s:REGEXPS.word_scope_word
endif

" ============================================================================
" Completion Plugin: phpcomplete-extended
" No config needed for deoplete
" ============================================================================

if exists("g:plugs['phpcomplete-extended']")
  autocmd dkocompletion FileType php
        \ setlocal completefunc=phpcomplete_extended#CompletePHP

  " https://github.com/Shougo/deoplete.nvim/blob/03f8cad9330a1ac557dfe7d12e8e77ba7f39d822/doc/deoplete.txt#L216
  let s:fip.php =
        \ s:REGEXPS.any_word
        \ . '\|' . '[^. \t]->\%(\h\w*\)\?'
        \ . '\|' . '\h\w*::\%(\h\w*\)\?'
endif

" ============================================================================
" Completion Plugin: phpcd.vim
" ============================================================================

if exists('g:plugs["phpcd.vim"]')
  augroup dkocompletion
    autocmd FileType php setlocal omnifunc=phpcd#CompletePHP
  augroup END

  let s:fip.php =
        \ s:REGEXPS.any_word
        \ . '\|' . s:REGEXPS.nonspace_arrow
        \ . '\|' . s:REGEXPS.word_scope_word
endif

" ============================================================================
" Completion Plugin: padawan.vim
" ============================================================================

if exists('g:plugs["padawan.vim"]')
  augroup dkocompletion
    autocmd FileType php setlocal omnifunc=padawan#Complete
  augroup END

  let s:fip.php =
        \ s:REGEXPS.any_word
        \ . '\|' . s:REGEXPS.nonspace_arrow
        \ . '\|' . s:REGEXPS.word_scope_word
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

  " Patterns that use neocomplete
  call dko#InitObject('g:neocomplete#sources#omni#input_patterns')
  call extend(g:neocomplete#sources#omni#input_patterns, s:neo_patterns)
endif

" ============================================================================
" Deoplete
" ============================================================================

if exists('g:plugs["deoplete.nvim"]')
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#auto_complete_start_length = 2
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
  call dko#InitObject('g:deoplete#omni#input#patterns')
  call extend(g:deoplete#omni#input#patterns, s:deo_patterns)

endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

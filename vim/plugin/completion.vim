" plugin/completion.vim
"
" See vice setup for stuff to steal
" @see <https://github.com/zeekay/vice-neocompletion/blob/master/autoload/vice/neocomplete.vim>
"

if !g:dko_has_completion | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

augroup dkocompletion
  autocmd!
augroup end

" ============================================================================
" Neosnippet
" ============================================================================

if dko#IsPlugged('neosnippet')
  " Snippets userdir
  let g:neosnippet#enable_snipmate_compatibility = 1
  let g:neosnippet#snippets_directory = g:dko#vim_dir . '/snippets'

  " Map honza/vim-snippets files to neosnippet's javascript set
  " The javascript.* set is included via 'javascript' but mocha is a separate
  " filetype
  let g:neosnippet#scope_aliases = {}
  let g:neosnippet#scope_aliases['javascript'] =
        \   'javascript'
        \.  ',javascript-mocha'

  " Keybindings for snippet completion
  " Pressing <TAB> with PUM open will move through results, but won't expand
  " unless I explicitly hit <C-f>
  imap  <special>   <C-f>   <Plug>(neosnippet_expand_or_jump)
  smap  <special>   <C-f>   <Plug>(neosnippet_expand_or_jump)
  xmap  <special>   <C-f>   <Plug>(neosnippet_expand_target)

  " Get rid of the placeholders in inserted snippets when done inserting
  augroup dkocompletion
    autocmd InsertLeave * NeoSnippetClearMarkers
  augroup END
endif

" ============================================================================
" Neocomplete / Deoplete
" ============================================================================

" ----------------------------------------------------------------------------
" Regexes to use completion engine
" See plugins sections too (e.g. phpcomplete and jspc)
" ----------------------------------------------------------------------------

let s:REGEX = {}
let s:REGEX.any_word        = '\h\w*'
let s:REGEX.nonspace        = '[^-. \t]'
let s:REGEX.nonspace_dot    = s:REGEX.nonspace . '\.\w*'
let s:REGEX.member = s:REGEX.nonspace . '->\w*'
let s:REGEX.static = s:REGEX.any_word . '::\w*'

" For jspc.vim
let s:REGEX.keychar   = '\k\zs \+'
let s:REGEX.parameter = s:REGEX.keychar . '\|' . '(' . '\|' . ':'

" Neocomplete -- if any of these match what you're typing, neocomplete will
" collect the omnifunc results and put them in the PUM with any other results.
" - String or list of vim regex
let s:neo_patterns = {}

" coffee
"let s:neo_patterns.coffee = '\h\w*\|[^. \t]\.\w*'

" javascript
" default: https://github.com/Shougo/neocomplete.vim/blame/34b42e76be30c0f365110ea036c8490b38fcb13e/autoload/neocomplete/sources/omni.vim
let s:neo_patterns.javascript =
      \ s:REGEX.any_word
      \ . '\|' . s:REGEX.nonspace_dot

" lua with xolox/vim-lua-ftplugin -- not used but correct
" https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1705
" let s:neo_patterns.lua = '\w\+[.:]\|require\s*(\?["'']\w*'

" perl
"let s:neo_patterns.perl   = '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

" php with phpcomplete.vim support
" https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1731
let s:neo_patterns.php =
    \ s:REGEX.any_word
    \ . '\|' . s:REGEX.member
    \ . '\|' . s:REGEX.static

" ----------------------------------------------------------------------------
" For Deoplete deo_patterns only
" ----------------------------------------------------------------------------

" Py3 regex notes:
" - \s is a space
let s:PY3REGEX = {}
let s:PY3REGEX.word = '\w+'

" For css and preprocessors
let s:PY3REGEX.starting_word  = '^\s*' . s:PY3REGEX.word
let s:PY3REGEX.css_media      = '^\s*@'
let s:PY3REGEX.css_value      = ': \w*'

" For jspc.vim
" parameter completion for window.addEventListener('___
let s:PY3REGEX.parameter = "\.\w+\('"

" For phpcomplete.vim
let s:PY3REGEX.member = '->\w*'
let s:PY3REGEX.static = s:PY3REGEX.word . '::\w*'

" ----------------------------------------------------------------------------
" Deoplete -- if any of these match what you're typing, deoplete will collect
" the omnifunc results and put them in the PUM with any other results.
" - Python 3 regex
" ----------------------------------------------------------------------------

let s:deo_patterns = {}

" Not using deoplete defaults from omni.py because if you hit <TAB> after
" a full rule, e.g. `margin: 1em;<TAB>` it will trigger completion of a new
" rule. These regexes only complete for one rule per line.
let s:deo_patterns.css  = [
      \   s:PY3REGEX.css_media,
      \   s:PY3REGEX.starting_word,
      \   s:PY3REGEX.starting_word . s:PY3REGEX.css_value,
      \   s:PY3REGEX.css_media . '\w*',
      \   s:PY3REGEX.css_media . s:PY3REGEX.css_value,
      \   s:PY3REGEX.css_value . '\s*!',
      \   s:PY3REGEX.css_value . '\s*!',
      \ ]
let s:deo_patterns.less = s:deo_patterns.css
let s:deo_patterns.sass = s:deo_patterns.css
let s:deo_patterns.scss = s:deo_patterns.css

" JS patterns are defined per plugin
let s:deo_patterns.javascript = []

" https://github.com/Shougo/deoplete.nvim/blob/5fc5ed772de138439322d728b103a7cb225cbf82/doc/deoplete.txt#L300
let s:deo_patterns.php = [
      \   s:PY3REGEX.word,
      \   s:PY3REGEX.member,
      \   s:PY3REGEX.static,
      \ ]

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

" ============================================================================
" Completion Plugin: vim-better-javascript-completion
" ============================================================================

if dko#IsPlugged('vim-better-javascript-completion')
  " insert instead of add, this is preferred completion omnifunc (except tern)
  autocmd dkocompletion FileType javascript setlocal omnifunc=js#CompleteJS
  call insert(s:omnifuncs.javascript, 'js#CompleteJS')
endif

" ============================================================================
" Completion Plugin: tern (both nvim and vim versions)
" This overrides all other JS completions when fip matches
" ============================================================================

if executable('npm')
  " tern_for_vim settings
  " It already sets the buffer's &omnifunc
  if executable('tern') && dko#IsPlugged('tern_for_vim')
    " Use global tern server instance (same as deoplete-ternjs)
    let g:tern#command   = [ 'tern' ]
    " Don't close tern after 5 minutes, helps speed up deoplete completion if
    " they manage to share the instance
    let g:tern#arguments = [ '--persistent' ]

    augroup dkocompletion
      autocmd FileType javascript nnoremap <silent><buffer> gd :<C-U>TernDef<CR>
    augroup END
  endif

  " deoplete-ternjs settings
  "let g:tern_show_argument_hints = 'on_hold'   " Use tabline instead (<F10>)
  let g:tern_request_timeout       = 1
  let g:tern_show_signature_in_pum = 1

  " Use tern for completion if either plugin is installed
  " if executable('tern') && (
  "       \ dko#IsPlugged('tern_for_vim') || dko#IsPlugged('deoplete-ternjs')
  "       \ )
    " force using tern when typing matches regex
    " first regex is match 5 or more characters to end of line
    "let s:fip.javascript = '\h\k\{4,}$' . '\|' .
    "let s:fip.javascript = s:REGEX.nonspace_dot
    "call add(s:deo_patterns.javascript, s:REGEX.nonspace_dot)
  " endif
endif

" ============================================================================
" Completion Plugin: jspc.vim
" (Ignored if s:fip.javascript was set by the above tern settings)
" ============================================================================

if dko#IsPlugged('jspc.vim')
  " <C-x><C-u> to manually use jspc in particular
  autocmd dkocompletion FileType javascript setlocal completefunc=jspc#omni

  " jspc.vim calls the javascriptcomplete#CompleteJS if it doesn't match, so
  " we don't need it in the omnifuncs
  call remove(
        \   s:omnifuncs.javascript,
        \   index(s:omnifuncs.javascript, 'javascriptcomplete#CompleteJS')
        \ )
  call add(s:omnifuncs.javascript, 'jspc#omni')

  " Triggered on quotes in `window.addEventListener('` for example
  call add(s:deo_patterns.javascript, s:PY3REGEX.parameter)
endif

" ============================================================================
" Completion Plugin: phpcd.vim
" ============================================================================

if dko#IsPlugged('phpcd.vim')
  " Call omnifunc directly
  let s:fip.php = s:REGEX.any_word
        \. '\|' . s:REGEX.member
        \. '\|' . s:REGEX.static
  let s:deo_patterns.php = []

" ============================================================================
" Completion Plugin: padawan.vim
" ============================================================================

elseif dko#IsPlugged('padawan.vim')
  augroup dkocompletion
    autocmd FileType php setlocal omnifunc=padawan#Complete
  augroup END

" ============================================================================
" Completion Plugin: phpcomplete-extended
" Includes neocomplete source.
" This requires vimproc and composer.json in project root.
" ============================================================================

elseif dko#IsPlugged('phpcomplete-extended')
  let g:phpcomplete_extended_auto_add_use = 0
  if executable('composer')
    let g:phpcomplete_index_composer_command = 'composer'
  endif

  autocmd dkocompletion FileType php
        \ setlocal omnifunc=phpcomplete_extended#CompletePHP

  let s:omnifuncs.php = [ 'phpcomplete_extended#CompletePHP' ]
endif

" ============================================================================
" Completion Plugin: phpcomplete.vim
" Don't need to check exists since an older one comes with vimruntime.
" This is the worst one, moves the cursor, reads tags files
" ============================================================================

if dko#IsPlugged('phpcomplete.vim')
  " Settings are read when phpcomplete#CompletePHP is called
  let g:phpcomplete_parse_docblock_comments = 1

  " phpcomplete and universal-ctags suck
  " These two options essentially disable ctag searching for vars and
  " namespaces. Works, for now, though.
  "
  " @see https://github.com/shawncplus/phpcomplete.vim/wiki/Getting-better-tags
  " @see https://github.com/universal-ctags/ctags/issues/815
  " @see https://github.com/shawncplus/phpcomplete.vim/issues/89
  " @see https://github.com/shawncplus/phpcomplete.vim/search?q=ctags&type=Issues&utf8=%E2%9C%93
  " let g:phpcomplete_search_tags_for_variables = 0
  " let g:phpcomplete_min_num_of_chars_for_namespace_completion = 999

  autocmd dkocompletion FileType php
        \ setlocal completefunc=phpcomplete#CompletePHP
endif

" ============================================================================
" Neocomplete
" ============================================================================

if dko#IsPlugged('neocomplete')
  let g:neocomplete#data_directory =
        \ expand(g:dko#vim_dir . '/.tmp/neocomplete')

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

  call dko#InitDict('g:neocomplete#sources#omni#functions')
  call extend(g:neocomplete#sources#omni#functions, s:omnifuncs)

  " --------------------------------------------------------------------------
  " Input patterns
  " --------------------------------------------------------------------------

  " Patterns that bypass to &omnifunc
  call dko#InitDict('g:neocomplete#force_omni_input_patterns')
  call extend(g:neocomplete#force_omni_input_patterns, s:fip)

  " Patterns that use neocomplete
  call dko#InitDict('g:neocomplete#sources#omni#input_patterns')
  call extend(g:neocomplete#sources#omni#input_patterns, s:neo_patterns)
endif

" ============================================================================
" Deoplete
" ============================================================================

if dko#IsPlugged('deoplete.nvim')
  let g:deoplete#enable_ignore_case = 0
  let g:deoplete#enable_smart_case = 1
  let g:deoplete#enable_at_startup  = 1

  " [file] candidates are relative to the buffer path
  let g:deoplete#file#enable_buffer_path = 1

  call deoplete#custom#set('_', 'matchers', [
        \   'matcher_head',
        \   'matcher_length',
        \ ])

  " --------------------------------------------------------------------------
  " Sources for engine based omni-completion (ignored if match s:fip)
  " Unlike neocomplete, deoplete only supports one omnifunction at a time
  " --------------------------------------------------------------------------

  call dko#InitDict('g:deoplete#omni#functions')
  " Not extending, instead pluck first item from list since deoplete only
  " supports one omnifunc
  call extend(g:deoplete#omni#functions, map(copy(s:omnifuncs), 'v:val[0]'))

  " --------------------------------------------------------------------------
  " Input patterns
  " --------------------------------------------------------------------------

  " Patterns that bypass deoplete and use &omnifunc directly
  call dko#InitDict('g:deoplete#omni_patterns')
  call extend(g:deoplete#omni_patterns, s:fip)

  " Patterns that trigger deoplete aggregated PUM
  call dko#InitDict('g:deoplete#omni#input_patterns')
  call extend(g:deoplete#omni#input_patterns, s:deo_patterns)

endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

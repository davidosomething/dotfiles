" plugin/completion.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

augroup dkocompletion
  autocmd!
  autocmd FileType php setlocal omnifunc=
augroup END

" ============================================================================
" Deoplete
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
" single quote escaped as ''
" literal parentheses escaped as \(
let s:PY3REGEX.parameter = '\.\w+\('''

" For phpcomplete.vim
let s:PY3REGEX.member = '->\w*'
let s:PY3REGEX.static = s:PY3REGEX.word . '::\w*'

" ----------------------------------------------------------------------------
" Deoplete -- if any of these match what you're typing, deoplete will collect
" the omnifunc results and put them in the PUM with any other results.
" - Python 3 regex
" ----------------------------------------------------------------------------

" If you set a filetype key, completion will ONLY be triggered for the
" matching regex; so leave unset if possible.
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
let s:deo_patterns.javascript = [
      \   s:PY3REGEX.word,
      \ ]

" https://github.com/Shougo/deoplete.nvim/blob/5fc5ed772de138439322d728b103a7cb225cbf82/doc/deoplete.txt#L300
" let s:deo_patterns.php = [
"       \   s:PY3REGEX.word,
"       \   s:PY3REGEX.member,
"       \   s:PY3REGEX.static,
"       \ ]

" ----------------------------------------------------------------------------
" Regexes to force omnifunc completion
" See plugins sections too (e.g. tern)
" ----------------------------------------------------------------------------

" When defined for a filetype, call the omnifunc directly (feedkeys
" <C-X><C-O>) instead of delegating to completion plugin. See each plugin
" section for settings.
" deoplete dict:    g:deoplete#omni_patterns
" - string vim regex
let s:omni_only = get(g:, 'deoplete#_omni_patterns', {})

" c-type with clang_complete -- not used but correct
" let s:omni_only.c =       '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?',
" let s:omni_only.cpp =     '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?',
" let s:omni_only.objc =    '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
" let s:omni_only.objcpp =  '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'

" ruby with Shougo/neocomplete-rsense -- not used but correct
" https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1605
" let s:omni_only.ruby = '[^. *\t]\.\w*\|\h\w*::'

" python with davidhalter/jedi-vim -- not used but correct
" https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1617
" let s:omni_only.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

" typescript with Quramy/tsuquyomi -- not used but correct
" let s:omni_only.typescript = '[^. \t]\.\%(\h\w*\)\?'
" let s:omni_only.typescript = '\h\w*\|[^. \t]\.\w*' -- maybe more relaxed

" ----------------------------------------------------------------------------
" Omnifunc for each filetype
" ----------------------------------------------------------------------------

" When triggering a completion within an engine, use these omnifuncs
" deoplete    g:deoplete#omni#functions
" - list of omnifunc function names
let s:omnifuncs = {
      \   'javascript': [ 'javascriptcomplete#CompleteJS' ],
      \   'html':       [ 'htmlcomplete#CompleteTags' ],
      \ }

" ============================================================================
" Helper functions
" ============================================================================

" Include an omnifunc from deoplete aggregation
"
" @param {String} ft
" @param {String} funcname
function! s:Include(ft, funcname) abort
  call insert(s:omnifuncs[a:ft], a:funcname)
endfunction

" Exclude an omnifunc from deoplete aggregation
"
" @param {String} ft
" @param {String} funcname
function! s:Exclude(ft, funcname) abort
  call remove(
        \   s:omnifuncs[a:ft],
        \   index(s:omnifuncs[a:ft], a:funcname)
        \ )
endfunction

" Trigger deoplete aggregated omnifunc when matching this regex
"
" @param {String} ft
" @param {List} regexps
" @param {List} [a:] a:1 clear?
function! s:Trigger(ft, regexps, ...) abort
  if !empty(a:000)
    let s:deo_patterns[a:ft] = a:regexps
  else
    call extend(s:deo_patterns[a:ft], a:regexps)
  endif
endfunction

" ============================================================================
" Completion Plugin: vim-better-javascript-completion
" ============================================================================

if dko#IsPlugged('vim-better-javascript-completion')
  " insert instead of add, this is preferred completion omnifunc (except tern)
  autocmd dkocompletion FileType javascript setlocal omnifunc=js#CompleteJS
  call s:Include('javascript', 'js#CompleteJS')
endif

" ============================================================================
" Completion Plugin: tern (both nvim and vim versions)
" This overrides all other JS completions when omni_only matches
" ============================================================================

if executable('tern')

  " --------------------------------------------------------------------------
  " tern_for_vim settings
  " This plugin is used for its refactoring and helper methods, not completion
  " --------------------------------------------------------------------------

  " @TODO deprecated, replace with own plugin
  if dko#IsPlugged('tern_for_vim')
    " Use tabline instead (<F10>)
    let g:tern_show_argument_hints = 'no'

    let g:tern_request_timeout       = 1

    " Don't set the omnifunc to tern#Complete
    "let g:tern_set_omni_function     = 0
    " Useless since not using omnifunc
    let g:tern_show_signature_in_pum = 1

    augroup dkocompletion
      autocmd FileType javascript nnoremap <silent><buffer> gd :<C-U>TernDef<CR>
    augroup END
  endif

  " --------------------------------------------------------------------------
  " deoplete-ternjs settings
  " This plugin adds a custom deoplete source only
  " --------------------------------------------------------------------------

  " Use global tern server instance (same as deoplete-ternjs)
  let g:tern#command   = [ 'tern' ]
  " Don't close tern after 5 minutes, helps speed up deoplete completion if
  " they manage to share the instance
  let g:tern#arguments = [ '--persistent' ]

endif

" ============================================================================
" Completion Plugin: jspc.vim
" (Ignored if s:omni_only.javascript was set by the above tern settings)
" ============================================================================

if dko#IsPlugged('jspc.vim')
  " <C-x><C-u> to manually use jspc in particular
  autocmd dkocompletion FileType javascript setlocal completefunc=jspc#omni

  " jspc.vim calls the original &omnifunc (probably
  " javascriptcomplete#CompleteJS or tern#Complete) if it doesn't match, so we
  " don't need it in the deoplete omnifuncs
  call s:Exclude('javascript', 'javascriptcomplete#CompleteJS')
  call s:Include('javascript', 'jspc#omni')
  " Triggered on quotes in `window.addEventListener('` for example
  call s:Trigger('javascript', [
        \   s:PY3REGEX.parameter,
        \ ])
endif

" ============================================================================
" Completion Plugin: deoplete-padawan
" ============================================================================

if dko#IsPlugged('deoplete-padawan')

" ============================================================================
" Completion Plugin: phpcd.vim
" ============================================================================

elseif dko#IsPlugged('phpcd.vim')
  " Call omnifunc directly
  let s:omni_only.php = s:REGEX.any_word
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
  " Sources for engine based omni-completion (ignored if match s:omni_only)
  " --------------------------------------------------------------------------

  call dko#InitDict('g:deoplete#omni#functions')
  " Not extending, instead pluck first item from list since deoplete only
  " supports one omnifunc
  call extend(g:deoplete#omni#functions, map(copy(s:omnifuncs), 'v:val[0]'))

  " --------------------------------------------------------------------------
  " Input patterns
  " --------------------------------------------------------------------------

  " Patterns that use &omnifunc directly by synthetic <C-X><C-O>
  call dko#InitDict('g:deoplete#omni_patterns')
  call extend(g:deoplete#omni_patterns, s:omni_only)

  " Patterns that trigger deoplete aggregated PUM
  call dko#InitDict('g:deoplete#omni#input_patterns')
  call extend(g:deoplete#omni#input_patterns, s:deo_patterns)
endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

" See vice setup for stuff to steal
" @see <https://github.com/zeekay/vice-neocompletion/blob/master/autoload/vice/neocomplete.vim>

if !g:dko_has_completion | finish | endif

" ============================================================================
" Default bundled omni-completion for each filetype
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
" Neocomplete / Deoplete shared
" ============================================================================

" Omni input patterns: when defined for a filetype, typing something that
" matches this pattern will trigger omnifunc.
" neocomplete dict: g:neocomplete#sources#omni#input_patterns
let s:oip = {
      \   'coffee':     '\h\w*\|[^. \t]\.\w*',
      \   'perl':       '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?',
      \   'typescript': '[^. \t]\.\%(\h\w*\)\?',
      \ }
" javascript
" default: https://github.com/Shougo/neocomplete.vim/blame/34b42e76be30c0f365110ea036c8490b38fcb13e/autoload/neocomplete/sources/omni.vim
let s:oip.javascript = '\h\w*\|[^. \t]\.\w*'
" lua with xolox/vim-lua-ftplugin -- not used but correct
" https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1705
" let s:oip.lua = '\w\+[.:]\|require\s*(\?["'']\w*'
" php with phpcomplete.vim support
" https://github.com/Shougo/neocomplete.vim/blob/master/doc/neocomplete.txt#L1731
let s:oip.php = '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
" force using omnifunc (jedi) -- not used
" let s:oip.python = ''
" force using omnifunc (rsense) -- not used
" let s:oip.ruby = ''

" Forced omni input patterns: when defined for a filetype, call the omnifunc
" directly (feedkeys <C-X><C-O>) instead of delegating to completion plugin.
" neocomplete dict: g:neocomplete#force_omni_input_patterns
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

" Omnifunc groups, a list of omnifuncs to use all at once instead of just what
" is set for the buffer
" deoplete    g:deoplete#omni#functions
" neocomplete g:neocomplete#sources#omni#functions
" Continued in jspc and tern...
let s:omnifuncs = {
      \   'javascript': [ 'javascriptcomplete#CompleteJS' ],
      \   'sh':         [ 'syntaxcomplete#Complete' ],
      \ }

" ============================================================================
" jspc.vim
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
" vim-better-javascript-completion
" ============================================================================

if 1 && exists('g:plugs["vim-better-javascript-completion"]')
  " insert instead of add, will prefer this over javascript#CompleteJS (but
  " not over Tern, which is also prepended)
  call insert(s:omnifuncs.javascript, 'js#CompleteJS')
endif

" ============================================================================
" tern
" This overrides all other JS completions
" ============================================================================

if 1 && exists('g:plugs["tern_for_vim"]')
  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1

  augroup dkotern
    autocmd FileType javascript nnoremap <silent> <buffer> gb :TernDef<CR>
  augroup END

  " insert instead of add
  call insert(s:omnifuncs.javascript, 'tern#Complete')
  " force using omnicompletion (tern in this case)
  " Override all other completions by forcing omni completion?
  "let s:fip.javascript = '[^. \t]\.\w*'
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

  " triggers that start neocomplete omni-completion
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  for [s:ft, s:regexes] in items(s:oip)
    let g:neocomplete#sources#omni#input_patterns[s:ft] = s:regexes
  endfor

  " triggers that forced standard omni-completion 
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  for [s:ft, s:regexes] in items(s:fip)
    let g:neocomplete#force_omni_input_patterns[s:ft] = s:regexes
  endfor

  " --------------------------------------------------------------------------
  " Sources
  " --------------------------------------------------------------------------

  " if !exists('g:neocomplete#sources')
  "   let g:neocomplete#sources = {}
  " endif
  "let g:neocomplete#sources._ = [ 'omni', 'buffer' ]

  if !exists('g:neocomplete#sources#omni#functions')
    let g:neocomplete#sources#omni#functions = {}
  endif
  for [s:ft, s:funclist] in items(s:omnifuncs)
    let g:neocomplete#sources#omni#functions[s:ft] = s:funclist
  endfor
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

  " ----------------------------------------
  " Source setup
  " ----------------------------------------

  " let g:deoplete#sources = {}
  " let g:deoplete#sources._ = [ 'omni', 'buffer' ]

  " ----------------------------------------
  " Omnifunc sources
  " Unlike neocomplete, deoplete only supports one omnifunction
  " ----------------------------------------

  let g:deoplete#omni#functions = {}
  for [s:ft, s:funclist] in items(s:omnifuncs)
    let g:deoplete#omni#functions[s:ft] = s:funclist[0]
  endfor

  " ----------------------------------------
  " Input pattern
  " see https://github.com/Shougo/deoplete.nvim/blob/master/autoload/deoplete/init.vim
  " ----------------------------------------

  " deoplete
  " let g:deoplete#omni#input#patterns = {}
  " let g:deoplete#omni#input#patterns.sh = '\w+\.'

  " forced standard omni-completion
  " let g:deoplete#omni_patterns.sh = '\w+\.'
  " let g:deoplete#omni_patterns.xml  = '<[^>]*'
  " let g:deoplete#omni_patterns = {}
  " let g:deoplete#omni_patterns.html = '<[^>]*'
  " let g:deoplete#omni_patterns.md   = '<[^>]*'
  " let g:deoplete#omni_patterns.python = '\w+\.'
  " let g:deoplete#omni_patterns.php =
  "       \ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
  " let g:deoplete#omni_patterns.python = ['[^. *\t]\.\h\w*\','\h\w*::']
  " let g:deoplete#omni_patterns.python3 = ['[^. *\t]\.\h\w*\','\h\w*::']

endif

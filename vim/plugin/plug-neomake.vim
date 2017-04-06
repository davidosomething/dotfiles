" plugin/plug-neomake.vim
scriptencoding utf-8

if !dko#IsPlugged('neomake') | finish | endif

augroup dkoneomake
  autocmd!
augroup END

" ============================================================================
" Map
" ============================================================================

execute dko#MapAll({ 'key': '<F6>', 'command': 'Neomake' })
execute dko#MapAll({ 'key': '<F7>', 'command': 'Neomake!' })

" ============================================================================
" Output
" ============================================================================

" No output on :wq
" @see https://github.com/benekastah/neomake/issues/309
" @see https://github.com/benekastah/neomake/issues/329
autocmd dkoneomake VimLeave * let g:neomake_verbose = 0

" loclist
let g:neomake_open_list   = 0
let g:neomake_list_height = g:dko_loc_list_height

" aggregate errors
let g:neomake_serialize = 0

" ----------------------------------------------------------------------------
" Signs column
" ----------------------------------------------------------------------------

let g:neomake_error_sign    = { 'text': '⚑', 'texthl': 'NeomakeErrorSign' }
let g:neomake_warning_sign  = { 'text': '⚑', 'texthl': 'NeomakeWarningSign' }
let g:neomake_message_sign  = { 'text': '⚑', 'texthl': 'NeomakeMessageSign' }
let g:neomake_info_sign     = { 'text': '⚑', 'texthl': 'NeomakeInfoSign' }

" ============================================================================
" Define makers
" ============================================================================

" For using local NPM based makers (e.g. eslint):
" Resolve the maker's exe relative to the project of the file in buffer, as
" opposed to using the result of `system('npm bin')` since that executes
" relative to vim's working path (and gives a fake result of not in a node
" project). Lotta people doin` it wrong ಠ_ಠ

" @param dict settings
" @param string [settings.when]       eval()'d, add local maker only if true
" @param string settings.ft           filetype for the maker
" @param string settings.maker        maker's name
" @param string [settings.exe]        alternate exe path to use in the buffer
" @param string [settings.is_enabled] default true, auto-enable when defined
function! s:AddLocalMaker(settings) abort
  " We eval this so it runs with the buffer context
  if has_key(a:settings, 'when') && !eval(a:settings['when'])
    return
  endif

  " Override maker's exe for this buffer?
  let l:exe = dkoproject#GetBin(get(a:settings, 'exe', ''))
  if !empty(l:exe)
    let b:neomake_{a:settings['ft']}_{a:settings['maker']}_exe = l:exe
  endif

  " Automatically enable the maker for this buffer?
  let l:is_enabled = get(a:settings, 'is_enabled', 1)
  if l:is_enabled && dko#IsMakerExecutable(a:settings['maker'])
    call add(
          \ dko#InitList('b:neomake_' . a:settings['ft'] . '_enabled_makers'),
          \ a:settings['maker'])
  endif
endfunction

" ----------------------------------------------------------------------------
" Java
" ----------------------------------------------------------------------------

" No java makers, use ALE instead until fixed:
" https://github.com/neomake/neomake/issues/875
let g:neomake_java_enabled_makers = []

" ----------------------------------------------------------------------------
" JavaScript
" ----------------------------------------------------------------------------

" Sets b:neomake_javascript_enabled_makers based on what is present in the
" project
function! s:PickJavascriptMakers() abort
  " Find an eslintrc in current project. If not found use jshint
  if !empty(dkoproject#GetEslintrc())
    let l:eslint_maker = neomake#GetMaker('eslint', 'javascript')
    let l:eslint_args = get(
          \ g:, 'neomake_javascript_eslint_args',
          \ l:eslint_maker.args)
    let b:neomake_javascript_eslint_args =
          \ l:eslint_args + [ '-c', dkoproject#GetEslintrc() ]

  " This project uses jshint instead of eslint, disable eslint
  elseif exists('b:neomake_javascript_enabled_makers')
        \ && dko#IsMakerExecutable('jshint')
        \ && !empty(dkoproject#GetFile('.jshintrc'))
    " Remove eslint from enabled makers, use only jshint
    let b:neomake_javascript_enabled_makers = filter(
          \   b:neomake_javascript_enabled_makers,
          \   "v:val !~? 'eslint'"
          \ )
  endif
endfunction

" Run these makers by default on :Neomake
let g:neomake_javascript_enabled_makers =
      \ executable('eslint') ? ['eslint'] : []

" Override/create these makers as buffer local ones, and enable them
let s:local_eslint = {
      \   'ft':    'javascript',
      \   'maker': 'eslint',
      \   'exe':   'node_modules/.bin/eslint',
      \   'when':  '!empty(dkoproject#GetEslintrc())'
      \ }

let s:local_jshint = {
      \   'ft':    'javascript',
      \   'maker': 'jshint',
      \   'exe':   'node_modules/.bin/jshint',
      \   'when':  'empty(dkoproject#GetEslintrc())'
      \ }

autocmd dkoneomake FileType javascript
      \ call s:AddLocalMaker(s:local_eslint)
      \| call s:AddLocalMaker(s:local_jshint)
      \| call s:PickJavascriptMakers()

" ----------------------------------------------------------------------------
" Markdown and Pandoc
" ----------------------------------------------------------------------------

function! s:SetupMarkdownlint() abort
  " This is totally different from using local eslint -- don't like what
  " neomake has by default.

  let l:maker = { 'errorformat':  '%f: %l: %m' }

  " Use config local to project if available
  let l:config = dkoproject#GetFile('markdownlint.json')
  if empty(l:config)
    let l:config = dkoproject#GetFile('.markdownlintrc')
  endif
  if empty(l:config)
    let l:config = glob(expand('$DOTFILES/markdownlint/config.json'))
  endif
  let l:maker.args = empty(l:config) ? [] : ['--config', l:config]

  let b:neomake_markdown_markdownlint_args = l:maker.args
  let b:neomake_pandoc_markdownlint_args = l:maker.args

  " Use markdownlint in local node_modules/ if available
  let l:bin = 'node_modules/.bin/markdownlint'
  let l:maker.exe = !empty(l:bin) ? 'markdownlint' : l:bin

  " Bail if not installed either locally or globally
  if !executable(l:maker.exe)
    return
  endif

  let b:neomake_markdown_markdownlint_maker = l:maker
  let b:neomake_pandoc_markdownlint_maker = l:maker
endfunction
" Stupid composite filetypes
autocmd dkoneomake FileType
      \ markdown.pandoc,markdown,pandoc
      \ call s:SetupMarkdownlint()

" ----------------------------------------------------------------------------
" PHP: phpcs, phpmd
" ----------------------------------------------------------------------------

let s:phpcs_psr2 = ['--standard=PSR2']

let s:phpcs_wordpress = ['--standard=WordPress-Extra']
          \ + ['--runtime-set', 'installed_paths', expand('~/src/wpcs')]
          \ + ['--exclude=WordPress.PHP.YodaConditions']

function! s:SetPhpcsStandard() abort
  " WordPress
  if expand('%:p') =~? 'content/\(mu-plugins\|plugins\|themes\)'
        \ || expand('%:p') =~? 'ed-com'
    let b:neomake_php_phpcs_args = neomake#makers#ft#php#phpcs().args
          \ + s:phpcs_wordpress
  else
    let b:neomake_php_phpcs_args = neomake#makers#ft#php#phpcs().args
          \ + s:phpcs_psr2
  endif
endfunction

function! s:SetPhpmdRuleset() abort
  let l:ruleset_file = dkoproject#GetFile('ruleset.xml')

  if !empty(l:ruleset_file)
    " source, format, ruleset(xml file or comma sep list of default rules)
    let b:neomake_php_phpmd_args = [
          \   '%:p',
          \   'text',
          \   l:ruleset_file,
          \ ]
  endif
endfunction

let s:local_phpcs = {
      \   'ft':     'php',
      \   'maker':  'phpcs',
      \   'exe':    'vendor/bin/phpcs',
      \ }

autocmd dkoneomake FileType php
      \ call s:AddLocalMaker(s:local_phpcs)
      \| call s:SetPhpcsStandard()
      \| call s:SetPhpmdRuleset()

" ----------------------------------------------------------------------------
" Python
" ----------------------------------------------------------------------------

let g:neomake_python_enabled_makers = [
      \   'python', 'pep8', 'pyflakes', 'pylint'
      \ ]

" Add disable to defaults
" @see https://github.com/neomake/neomake/blob/master/autoload/neomake/makers/ft/python.vim#L26
let g:neomake_python_pylint_args = [
      \   '--output-format=text',
      \   '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg}"',
      \   '--reports=no',
      \   '--disable=locally-disabled',
      \ ]

" ----------------------------------------------------------------------------
" Sass: sasslint
" ----------------------------------------------------------------------------

function! s:SetSasslintRc() abort
  let l:sasslint_maker = neomake#GetMaker('sasslint', 'scss')
  let l:sasslint_args = get(
        \ g:, 'neomake_scss_sasslint_args',
        \ l:sasslint_maker.args)

  " Use local config if exists
  let l:config = dkoproject#GetFile('.sass-lint.yml')

  " Fall back to my global config
  if empty(l:config)
    let l:config = glob(expand('$DOTFILES/sasslint/.sass-lint.yml'))
  endif

  let b:neomake_scss_sasslint_args =
        \ l:sasslint_args + ['--config=' . l:config]
endfunction

let s:local_sasslint = {
      \   'ft':     'scss',
      \   'maker':  'sasslint',
      \   'exe':    'node_modules/.bin/sass-lint',
      \ }

function! s:PickScssMakers() abort
  if empty(dkoproject#GetFile('.scss-lint.yml')) | return
  endif

  " Only if scss-lint is executable (globally or locally)
  if !dko#IsMakerExecutable('scsslint') | return
  endif

  " Remove sasslint from enabled makers, use only scsslint
  let b:neomake_scss_enabled_makers = filter(
        \   copy(get(b:, 'neomake_scss_enabled_makers', [])),
        \   "v:val !~? 'sasslint'"
        \ )
endfunction

autocmd dkoneomake FileType scss
      \ call s:SetSasslintRc()
      \| call s:AddLocalMaker(s:local_sasslint)
      \| call s:PickScssMakers()

" ----------------------------------------------------------------------------
" VimL
" ----------------------------------------------------------------------------

" this is the default setting these days (vint only, vimlint is disabled)
"let g:neomake_vim_enabled_makers = ['vint']

" ============================================================================
" Should we :Neomake?
" ============================================================================

function! s:MaybeNeomake() abort
  " Not a real file
  if &buftype ==# 'nofile' | return | endif

  " File was never written
  if empty(glob(expand('%'))) | return | endif

  Neomake
endfunction

" ============================================================================
" Auto run
" Keep this last so all the other autocmds happen first
" ============================================================================

autocmd dkoneomake      BufWritePost,FileChangedShellPost
      \ *
      \ call s:MaybeNeomake()

autocmd dkostatusline   User
      \ NeomakeCountsChanged
      \ call dkostatus#Refresh()

autocmd dkostatusline   User
      \ NeomakeFinished
      \ call dkostatus#Refresh()


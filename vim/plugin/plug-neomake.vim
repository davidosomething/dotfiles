" plugin/plug-neomake.vim
scriptencoding utf-8

if !exists('g:plugs["neomake"]') | finish | endif

augroup dkoneomake
  autocmd!
augroup END

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

" disable airline integration
let g:neomake_airline = 0

" ----------------------------------------------------------------------------
" Signs column
" ----------------------------------------------------------------------------

let g:neomake_error_sign    = { 'text': '⚑' }
let g:neomake_warning_sign  = { 'text': '⚑' }

" ============================================================================
" Define makers
" ============================================================================

" For using local NPM based makers (e.g. eslint):
" Resolve the maker's exe relative to the project of the file in buffer, as
" opposed to using the result of `system('npm bin')` since that executes
" relative to vim's working path (and gives a fake result of not in a node
" project). Lotta people doin` it wrong ಠ_ಠ

" settings is a dict { ft, maker, local }
function! s:AddLocalMaker(settings) abort
  " Use local binary
  let l:bin = dkoproject#GetProjectConfigFile(a:settings['local'])
  if !empty(l:bin)
    let b:neomake_{a:settings['ft']}_{a:settings['maker']}_exe = l:bin
  endif

  " Enable the maker
  if !empty(l:bin)
    " Init b: variable as list if not exists
    let b:neomake_{a:settings['ft']}_enabled_makers = get(
          \   b:,
          \   'neomake_' . a:settings['ft'] . '_enabled_makers',
          \   []
          \ )
    " Add new local maker to list
    call add(b:neomake_{a:settings['ft']}_enabled_makers, a:settings['maker'])
  endif
endfunction

" The maker exe exists globally or was registered as a local
" maker (so local exe exists)
function! s:HasMakerExe(ft, maker, ...) abort
  let l:exe = get(a:, 1, a:maker)
  return executable(l:exe)
        \ || (exists('b:neomake_' . a:ft . '_enabled_makers')
        \     && index(b:neomake_{a:ft}_enabled_makers, a:maker) > -1)
endfunction

" ----------------------------------------------------------------------------
" JavaScript
" ----------------------------------------------------------------------------

let g:neomake_javascript_enabled_makers =
      \ executable('eslint') ? [ 'eslint' ] : []

let s:local_maker_eslint = {
      \   'ft':     'javascript',
      \   'maker':  'eslint',
      \   'local':  'node_modules/.bin/eslint',
      \ }

let s:local_maker_jscs = {
      \   'ft':     'javascript',
      \   'maker':  'jscs',
      \   'local':  'node_modules/.bin/jscs',
      \ }

let s:local_maker_jshint = {
      \   'ft':     'javascript',
      \   'maker':  'jshint',
      \   'local':  'node_modules/.bin/jshint',
      \ }

function! s:PickJavascriptMakers() abort
  " If there's a jshintrc file, use jshint instead of eslint
  if empty(dkoproject#GetProjectConfigFile('.jshintrc')) | return
  endif

  " Only if jshint is executable (globally or locally)
  if !s:HasMakerExe('javascript', 'jshint') | return
  endif

  " Remove eslint from enabled makers, use only jshint
  let b:neomake_javascript_enabled_makers = filter(
        \   copy(get(b:, 'neomake_javascript_enabled_makers', [])),
        \   "v:val !~? 'eslint'"
        \ )
endfunction

autocmd dkoneomake FileType javascript
      \ call s:AddLocalMaker(s:local_maker_eslint)
      \| call s:AddLocalMaker(s:local_maker_jscs)
      \| call s:AddLocalMaker(s:local_maker_jshint)
      \| call s:PickJavascriptMakers()

" ----------------------------------------------------------------------------
" Markdown
" ----------------------------------------------------------------------------

" Let pandoc use markdownlint as well
let g:neomake_pandoc_markdownlint_maker = neomake#GetMaker(
      \ 'markdownlint',
      \ 'markdown'
      \ )

let g:neomake_markdown_enabled_makers =
      \ executable('markdownlint') ? [ 'markdownlint' ] : []
let g:neomake_pandoc_enabled_makers = g:neomake_markdown_enabled_makers

function! s:SetupMarkdownlint()
  " This is totally different from using local eslint -- don't like what
  " neomake has by default.

  let l:maker = { 'errorformat':  '%f: %l: %m' }

  " Use config local to project if available
  let l:config = dkoproject#GetProjectConfigFile('markdownlint.json')
  if empty(l:config)
    let l:config = dkoproject#GetProjectConfigFile('.markdownlintrc')
  endif
  if empty(l:config)
    let l:config = glob(expand('$DOTFILES/markdownlint/config.json'))
  endif
  let l:maker.args = empty(l:config) ? [] : [ '--config', l:config ]

  let b:neomake_markdown_markdownlint_args = l:maker.args
  let b:neomake_pandoc_markdownlint_args = l:maker.args

  " Use markdownlint in local node_modules/ if available
  let l:bin = dkoproject#GetProjectConfigFile('node_modules/.bin/markdownlint')
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

function! s:SetPhpcsStandard()
  " WordPress
  if expand('%:p') =~? 'content/\(mu-plugins\|plugins\|themes\)'
    let b:neomake_php_phpcs_args = neomake#makers#ft#php#phpcs().args
          \ + [ '--runtime-set', 'installed_paths', '~/src/wpcs' ]
          \ + [ '--standard=WordPress-Extra' ]
          \ + [ '--exclude=WordPress.PHP.YodaConditions' ]
  endif
endfunction

function! s:SetPhpmdRuleset()
  let l:ruleset_file = dkoproject#GetProjectConfigFile('ruleset.xml')

  if !empty(l:ruleset_file)
    " source, format, ruleset(xml file or comma sep list of default rules)
    let b:neomake_php_phpmd_args = [
          \   '%:p',
          \   'text',
          \   l:ruleset_file,
          \ ]
  endif
endfunction

let s:local_maker_phpcs = {
      \   'ft':     'php',
      \   'maker':  'phpcs',
      \   'local':  'vendor/bin/phpcs',
      \ }

autocmd dkoneomake FileType php
      \ call s:AddLocalMaker(s:local_maker_phpcs)
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

function! s:SetSasslintRc()
  let l:sasslint_maker = neomake#GetMaker('sasslint', 'scss')
  let l:sasslint_args = get(
        \ g:, 'neomake_scss_sasslint_args',
        \ l:sasslint_maker.args)

  " Use local config if exists
  let l:config = dkoproject#GetProjectConfigFile('.sass-lint.yml')

  " Fall back to my global config
  if empty(l:config)
    let l:config = glob(expand('$DOTFILES/sasslint/.sass-lint.yml'))
  endif

  let b:neomake_scss_sasslint_args =
        \ l:sasslint_args + [ '--config=' . l:config ]
endfunction

let s:local_maker_sasslint = {
      \   'ft':     'scss',
      \   'maker':  'sasslint',
      \   'local':  'node_modules/.bin/sass-lint',
      \ }

function! s:PickScssMakers() abort
  if empty(dkoproject#GetProjectConfigFile('.scss-lint.yml')) | return
  endif

  " Only if scss-lint is executable (globally or locally)
  if !s:HasMakerExe('scss', 'scsslint', 'scss-lint') | return
  endif

  " Remove sasslint from enabled makers, use only scsslint
  let b:neomake_scss_enabled_makers = filter(
        \   copy(get(b:, 'neomake_scss_enabled_makers', [])),
        \   "v:val !~? 'sasslint'"
        \ )
endfunction

autocmd dkoneomake FileType scss
      \ call s:SetSasslintRc()
      \| call s:AddLocalMaker(s:local_maker_sasslint)
      \| call s:PickScssMakers()

" ----------------------------------------------------------------------------
" VimL
" ----------------------------------------------------------------------------

" vimlint is disabled, run on cli only
let g:neomake_vim_enabled_makers = [ 'vint' ]

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


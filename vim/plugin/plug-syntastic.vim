" plugin/plug-syntastic.vim
scriptencoding utf-8

if !exists("g:plugs['syntastic']") | finish | endif

augroup dkosyntastic
  autocmd!
augroup END

" ============================================================================
" Syntastic config
" ============================================================================

" ----------------------------------------------------------------------------
" When to check
" ----------------------------------------------------------------------------

let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq   = 0
let g:syntastic_mode_map = {
      \   'mode': 'active',
      \   'passive_filetypes': [],
      \ }

" ----------------------------------------------------------------------------
" Display results
" ----------------------------------------------------------------------------

if !exists("g:plugs['vim-airline']")
  let g:syntastic_stl_format='%E{⚑%e}%B{ }%W{⚑%w}'
endif

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 2 " autoclose only
let g:syntastic_loc_list_height          = g:dko_loc_list_height
let g:syntastic_aggregate_errors         = 1
let g:syntastic_enable_balloons          = 0

" Signs
let g:syntastic_enable_signs         = 1
let g:syntastic_error_symbol         = '⚑'
let g:syntastic_warning_symbol       = '⚑'
let g:syntastic_style_error_symbol   = '⚑'
let g:syntastic_style_warning_symbol = '⚑'

" ----------------------------------------------------------------------------
" How to check
" ----------------------------------------------------------------------------

" Map some filetypes, e.g. turn off html checkers on handlebars (I'm using my
" hbstidy instead of html tidy)
let g:syntastic_filetype_map = {
      \   'html.handlebars': 'handlebars',
      \   'markdown.pandoc': 'markdown',
      \ }

let g:syntastic_ignore_files = [
      \ '\m\.min\.js$',
      \ '\m\.min\.css$',
      \ ]

" ============================================================================
" Checker: HTML, Handlebars
" ============================================================================

let g:syntastic_handlebars_checkers  = ['handlebars', 'hbstidy']

let g:syntastic_html_tidy_ignore_errors = [
      \   '<fb:',
      \   'discarding unexpected </fb:',
      \   ' proprietary attribute "ng-',
      \   ' proprietary attribute "itemprop',
      \   ' proprietary attribute "itemscope',
      \   ' proprietary attribute "itemtype',
      \ ]

" Ignore handlebars stuff in tidy
let g:syntastic_html_tidy_ignore_errors = g:syntastic_html_tidy_ignore_errors
      \ + [
      \   ' allowed in <head> elements',
      \   '{{',
      \ ]

" ============================================================================
" Syntax: JS, Coffee
" ============================================================================

let g:syntastic_coffeescript_checkers  = ['coffee', 'coffeelint']

let g:syntastic_javascript_checkers = ['eslint']

let g:syntastic_javascript_eslint_quiet_messages = {
      \   'regex': 'File ignored because of your .eslintignore file.',
      \ }

autocmd dkosyntastic FileType javascript call dkoproject#AssignConfigPath(
      \ 'node_modules/.bin/eslint',
      \ 'b:syntastic_javascript_eslint_exec')

" syntastic: jscs if has .jscsrc
" @TODO disabled for now
let b:dko_jscsrc = dkoproject#GetProjectConfigFile('.jscsrc')
if (!empty(b:dko_jscsrc))
  "let b:syntastic_checkers = g:syntastic_javascript_checkers + ['jscs']
  let b:syntastic_javascript_jscs_post_args = '-c ' . b:dko_jscsrc
endif

" ============================================================================
" Syntax: Lua
" ============================================================================

let g:syntastic_lua_checkers = ['luac', 'luacheck']

" ============================================================================
" Syntax: Markdown
" ============================================================================

let g:syntastic_markdown_checkers = ['mdl']

let s:mdlrc = dkoproject#GetProjectConfigFile('.mdlrc')
if empty(s:mdlrc)
  let s:mdlrc = glob(expand('$DOTFILES/mdl/.mdlrc'))
endif
let g:syntastic_markdown_mdl_args = empty(s:mdlrc)
      \ ? ''
      \ : '--config ' . s:mdlrc
let g:syntastic_markdown_mdl_quiet_messages = {
      \   'regex': "No link definition for link ID '\[ x\]'",
      \ }

" ----------------------------------------------------------------------------
" Checker: markdownlint
" ----------------------------------------------------------------------------

" Use local markdownlint if available
autocmd dkosyntastic FileType markdown.pandoc call dkoproject#AssignConfigPath(
      \ 'node_modules/.bin/markdownlint',
      \ 'b:syntastic_markdown_mdl_exec')

" Use global markdownlint-cli npm package if not already set to local one
" Then pick what markdownlintrc to use
function! s:UseMarkdownLint() abort
  if !exists('b:syntastic_markdown_mdl_exec') && executable('markdownlint')
    let b:syntastic_markdown_mdl_exec = 'markdownlint'
  endif

  " Use project local or global markdownlintrc if available
  " Otherwise clear the args since they contain '--warnings' from mdl args
  if !empty(b:syntastic_markdown_mdl_exec)
    let l:ruleset = dkoproject#GetProjectConfigFile('.markdownlintrc')
    if empty(l:ruleset)
      let l:ruleset = glob(expand('$DOTFILES/markdownlint/config.json'))
    endif
    let b:syntastic_markdown_mdl_args = empty(l:ruleset)
          \ ? ''
          \ : '--config ' . l:ruleset
  endif
endfunction
autocmd dkosyntastic FileType markdown.pandoc call s:UseMarkdownLint()


" ============================================================================
" Syntax: PHP
" ============================================================================

let g:syntastic_php_checkers = ['php', 'phplint', 'phpmd', 'phpcs']

" ----------------------------------------------------------------------------
" Checker: phpmd
" ----------------------------------------------------------------------------

" Find local ruleset.xml
autocmd dkosyntastic FileType php call dkoproject#AssignConfigPath(
      \ 'ruleset.xml',
      \ 'b:syntastic_php_phpmd_post_args')

" ----------------------------------------------------------------------------
" Checker: phpcs
" ----------------------------------------------------------------------------

let g:syntastic_php_phpcs_quiet_messages = { 'regex': 'Yoda' }

function! s:FindPhpcsStandard()
  " WordPress VIP?
  if match(expand('%:p'), 'wp-\|plugins\|themes') > -1
    let b:syntastic_php_phpcs_args = '--standard=WordPress-VIP'
  endif
endfunction
autocmd dkosyntastic FileType php call s:FindPhpcsStandard()

" ============================================================================
" Syntax: Python
" ============================================================================

let g:syntastic_python_checkers = ['prospector', 'python']

" ============================================================================
" Syntax: scss
" ============================================================================

let g:syntastic_scss_checkers = [ 'sass' ]

" ----------------------------------------------------------------------------
" Checker: scss_lint
" ----------------------------------------------------------------------------

let s:dko_scsslint_config = expand('$DOTFILES/scss-lint/.scss-lint.yml')
if !empty(glob(s:dko_scsslint_config))
  let g:syntastic_scss_scss_lint_args = '--config=' . s:dko_scsslint_config
endif

" Set scss_lint config for current buffer
function! s:FindScsslintConfig()
  let l:config = dkoproject#GetProjectConfigFile('.scss-lint.yml')
  if !empty(l:config)
    let b:syntastic_scss_scss_lint_args = '--config=' . l:config
  endif
endfunction
autocmd dkosyntastic FileType scss call s:FindScsslintConfig()

" ----------------------------------------------------------------------------
" Checker: sass_lint
" ----------------------------------------------------------------------------

" Use local ruleset.xml
autocmd dkosyntastic FileType scss call dkoproject#AssignConfigPath(
      \ 'node_modules/.bin/sass-lint',
      \ 'b:syntastic_scss_sass_lint_exec')

function! s:SasslintFallback()
  if !exists('b:syntastic_scss_sass_lint_exec') && executable('sass-lint')
    let b:syntastic_scss_sass_lint_exec = 'sass-lint'
  endif
endfunction
autocmd dkosyntastic FileType scss call s:SasslintFallback()

" Set sass_lint config for current buffer
function! s:FindSasslintConfig()
  let l:config = dkoproject#GetProjectConfigFile('.sass-lint.yml')
  if !empty(l:config)
    let b:syntastic_scss_sass_lint_args = '--config=' . l:config
  endif
endfunction
autocmd dkosyntastic FileType scss call s:FindSasslintConfig()

let g:syntastic_scss_sass_lint_quiet_messages = {
      \   'regex': '-webkit-overflow-scrolling',
      \ }


" ----------------------------------------------------------------------------
" Checker assignment
" ----------------------------------------------------------------------------

function! s:AddScssCheckers()
  let b:syntastic_checkers = ['sass']

  " Found .scss-lint.yml
  if exists('b:syntastic_scss_scss_lint_args')
    let b:syntastic_checkers += ['scss_lint']
  endif

  " Found sass-lint node package
  if exists('b:syntastic_scss_sass_lint_exec')
    let b:syntastic_checkers += ['sass_lint']
  endif

  " Found stylelint node package
  if exists('b:syntastic_scss_stylelint_lint_exec')
    let b:syntastic_checkers += ['stylelint']
  endif
endfunction
autocmd dkosyntastic FileType scss call s:AddScssCheckers()

" ============================================================================
" Syntax: Shell
" ============================================================================

let g:syntastic_sh_checkers = [
      \   'bashate',
      \   'sh',
      \   'shellcheck',
      \ ]

let g:syntastic_zsh_checkers = [ 'zsh' ]

" disabled 'checkbashisms', don't like them
"let g:syntastic_sh_checkbashisms_args_after = '--posix'

" ============================================================================
" Syntax: VimL
" ============================================================================

" Syntastic checks if they're installed so don't need to check here.
let g:syntastic_vim_checkers = [ 'vint' ]

" ----------------------------------------------------------------------------
" Checker: vimlint
" ----------------------------------------------------------------------------

if exists("g:plugs['vim-vimlint']")
  call add(g:syntastic_vim_checkers, 'vimlint')

  call dko#InitObject('g:vimlint#config')
  let g:vimlint#config.EVL103 = 1

  let g:syntastic_vimlint_options = g:vimlint#config
endif

" ============================================================================
" Execution
" ============================================================================

" Check when filetype init/changed (still happens on initial ft detection)
autocmd dkosyntastic FileType * SyntasticCheck


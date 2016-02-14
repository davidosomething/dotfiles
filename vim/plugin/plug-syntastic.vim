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

" See ftplugin/javascript.vim, jscs enabled per-buffer if project has .jscsrc
let g:syntastic_javascript_checkers    = ['eslint']

let g:syntastic_javascript_eslint_quiet_messages = {
      \   'regex': 'File ignored because of your .eslintignore file.',
      \ }

function! s:UseLocalEslint() abort
  let l:eslint_binary = dkoproject#GetProjectRoot()
        \ . '/node_modules/.bin/eslint'
  if !empty(glob(l:eslint_binary))
    let b:syntastic_javascript_eslint_exec = l:eslint_binary
  endif
endfunction
autocmd dkosyntastic FileType javascript call s:UseLocalEslint()

" ============================================================================
" Syntax: Lua
" ============================================================================

let g:syntastic_lua_checkers = ['luac', 'luacheck']

" ============================================================================
" Syntax: Markdown
" ============================================================================

let g:syntastic_markdown_checkers = ['mdl']

let g:syntastic_markdown_mdl_quiet_messages = {
      \   'regex': "No link definition for link ID '\[ x\]'",
      \ }

" Use npm package markdownlint-cli instead of mdl gem
function! s:UseMarkdownLint() abort
  let l:markdownlint_binary = dkoproject#GetProjectRoot()
        \ . '/node_modules/.bin/markdownlint'
  if !empty(glob(l:markdownlint_binary))
    " Use local markdownlint-cli npm package
    let b:syntastic_markdown_mdl_exec = l:markdownlint_binary
  else
    if executable('markdownlint')
      " Use global markdownlint-cli npm package
      let b:syntastic_markdown_mdl_exec = 'markdownlint'
    endif
  endif

  if !empty(b:syntastic_markdown_mdl_exec)
    let l:ruleset = dkoproject#GetProjectConfigFile('.markdownlintrc')
    if !empty(l:ruleset)
      let b:syntastic_markdown_mdl_args = '--config ' . l:ruleset
    else
      let s:global_markdownlintrc =
            \ glob(expand('$DOTFILES/markdownlint/config.json'))
      if !empty(s:global_markdownlintrc)
        let b:syntastic_markdown_mdl_args = '--config '
              \. s:global_markdownlintrc
      endif
    endif
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

function! s:FindPhpmdRuleset()
  let l:ruleset = dkoproject#GetProjectConfigFile('ruleset.xml')
  if !empty(l:ruleset)
    let b:syntastic_php_phpmd_post_args = l:ruleset
  endif
endfunction
autocmd dkosyntastic FileType php call s:FindPhpmdRuleset()

" ----------------------------------------------------------------------------
" Checker: phpcs
" ----------------------------------------------------------------------------

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

let g:syntastic_scss_checkers = ['sass', 'scss_lint', 'stylelint']

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

" ============================================================================
" Syntax: Shell
" ============================================================================

let g:syntastic_sh_checkers = [ 'bashate', 'sh', 'shellcheck' ]
let g:syntastic_zsh_checkers = [ 'zsh' ]

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


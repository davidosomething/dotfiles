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
      \   'passive_filetypes': [ ],
      \ }

" Check when filetype init/changed (still happens on initial ft detection)
autocmd dkosyntastic FileType * SyntasticCheck

nnoremap <silent> S :Errors<CR>

" ----------------------------------------------------------------------------
" Display results
" ----------------------------------------------------------------------------

if !exists("g:plugs['vim-airline']")
  let g:syntastic_stl_format='%E{E:%e}%W{W:%w}'
endif

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 2 " autoclose only
let g:syntastic_loc_list_height          = g:dko_loc_list_height
let g:syntastic_aggregate_errors         = 1
let g:syntastic_enable_balloons          = 0

" Signs
let g:syntastic_enable_signs         = 1
let g:syntastic_error_symbol         = '☠'
let g:syntastic_style_error_symbol   = '☠'
let g:syntastic_warning_symbol       = '⚑'
let g:syntastic_style_warning_symbol = '⚑'

" ----------------------------------------------------------------------------
" How to check
" ----------------------------------------------------------------------------

" Map some filetypes, e.g. turn off html checkers on handlebars (I'm using my
" hbstidy instead of html tidy)
let g:syntastic_filetype_map = {
      \   'html.handlebars': 'handlebars',
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
" Checker: JS, Coffee
" ============================================================================

let g:syntastic_coffeescript_checkers  = ['coffee', 'coffeelint']

" See ftplugin/javascript.vim, jscs enabled per-buffer if project has .jscsrc
let g:syntastic_javascript_checkers    = ['eslint']

let g:syntastic_javascript_eslint_quiet_messages = {
      \   'regex': 'File ignored because of your .eslintignore file.',
      \ }

" ============================================================================
" Checker: Lua
" ============================================================================

let g:syntastic_lua_checkers = ['luac', 'luacheck']

" ============================================================================
" Checker: Markdown
" ============================================================================

let g:syntastic_markdown_mdl_quiet_messages = {
      \   'regex': "No link definition for link ID '\[ x\]'",
      \ }

" ============================================================================
" Checker: PHP
" ============================================================================

let g:syntastic_php_checkers = ['php', 'phpcs', 'phplint', 'phpmd']

" Set phpmd ruleset for current buffer
function! s:DKO_FindPhpmdRuleset()
  let l:ruleset = dkoproject#GetProjectConfigFile('ruleset.xml')
  if !empty(l:ruleset)
    let b:syntastic_php_phpmd_post_args = l:ruleset
  endif
endfunction
autocmd dkosyntastic BufReadPost *.php call s:DKO_FindPhpmdRuleset()

" ============================================================================
" Checker: Python
" ============================================================================

let g:syntastic_python_checkers = ['prospector', 'python']

" ============================================================================
" Checker: scss_lint
" ============================================================================

let g:syntastic_scss_checkers = ['sass', 'scss_lint', 'stylelint']
let s:dko_scsslint_config = expand('$DOTFILES/scss-lint/.scss-lint.yml')
if !empty(glob(s:dko_scsslint_config))
  let g:syntastic_scss_scss_lint_args = '--config=' . s:dko_scsslint_config
endif

" Set scss_lint config for current buffer
function! s:DKO_FindScsslintConfig()
  let l:config = dkoproject#GetProjectConfigFile('.scss-lint.yml')
  if !empty(l:config)
    let b:syntastic_scss_scss_lint_args = '--config=' . l:config
  endif
endfunction
autocmd dkosyntastic BufReadPost *.scss call s:DKO_FindScsslintConfig()

" ============================================================================
" Checker: Shell
" ============================================================================

let g:syntastic_sh_checkers = ['bashate', 'shellcheck']
let g:syntastic_zsh_checkers = g:syntastic_sh_checkers + ['zsh']

" ============================================================================
" Checker: VimL
" ============================================================================

" Syntastic checks if they're installed so don't need to check here.
let g:syntastic_vim_checkers = ['vint']

if exists("g:plugs['vim-vimlint']")
  call add(g:syntastic_vim_checkers, 'vimlint')

  call dko#init_object('g:vimlint#config')
  let g:vimlint#config.EVL103 = 1

  let g:syntastic_vimlint_options = g:vimlint#config
endif


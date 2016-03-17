" plugin/plug-syntastic.vim
scriptencoding utf-8

if !exists("g:plugs['syntastic']") | finish | endif

augroup dkosyntastic
  autocmd!
augroup END

" ============================================================================
" Syntastic config
" ============================================================================

" migrated to neomake
let s:disabled_fts = [
      \   'coffee',
      \   'css',
      \   'javascript',
      \   'json',
      \   'lua',
      \   'php',
      \   'scss',
      \   'vim',
      \   'yaml'
      \ ]

" ----------------------------------------------------------------------------
" When to check
" ----------------------------------------------------------------------------

let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq   = 0
let g:syntastic_mode_map = {
      \   'mode':               'active',
      \   'passive_filetypes':  s:disabled_fts,
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
  if exists('b:syntastic_markdown_mdl_exec')
        \ && !empty(b:syntastic_markdown_mdl_exec)
    let l:ruleset = dkoproject#GetProjectConfigFile('markdownlint.json')
    if empty(l:ruleset)
      let l:ruleset = dkoproject#GetProjectConfigFile('.markdownlintrc')
    endif
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
" Syntax: Python
" ============================================================================

let g:syntastic_python_checkers = ['prospector', 'python']

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
" Checkers: disabled (probably using neomake instead)
" ============================================================================

for s:ft in s:disabled_fts
  let g:syntastic_{s:ft}_checkers = []
endfor

" ============================================================================
" Execution
" ============================================================================

" Check when filetype init/changed (still happens on initial ft detection)
autocmd dkosyntastic FileType * SyntasticCheck


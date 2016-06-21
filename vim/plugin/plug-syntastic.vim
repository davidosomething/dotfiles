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
      \   'markdown',
      \   'php',
      \   'sh',
      \   'scss',
      \   'vim',
      \   'yaml',
      \   'zsh',
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
let g:syntastic_filetype_map = { 'html.handlebars': 'handlebars' }

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
" Syntax: Python
" ============================================================================

let g:syntastic_python_checkers = ['prospector', 'python']

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


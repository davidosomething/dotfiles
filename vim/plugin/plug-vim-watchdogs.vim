" plugin/plug-vim-watchdogs.vim

if !exists("g:plugs['vim-watchdogs']") | finish | endif

" ============================================================================
" check on idle
" ============================================================================

let g:watchdogs_check_CursorHold_enable = 1
let g:watchdogs_check_CursorHold_enables = {
      \   'javascript': 1,
      \ }

" ============================================================================
" check on write
" ============================================================================

let g:watchdogs_check_BufWritePost_enable_on_wq = 1
let g:watchdogs_check_BufWritePost_enable = 1
" filetypes to use on
let g:watchdogs_check_BufWritePost_enables = {
      \   'javascript': 1,
      \ }

" ============================================================================
" checkers to use
" ============================================================================

if !exists('g:quickrun_config')
  let g:quickrun_config = {}
endif

let g:quickrun_config['javascript/watchdogs_checker'] = {
      \   'type': 'watchdogs_checker/eslint',
      \ }

let g:quickrun_config['watchdogs_checker/eslint'] = {
      \   'command':              'eslint',
      \   'exec':                 '%c -f compact %o %s:p',
      \   'quickfix/errorformat': '%f:%l:%c \[E\] %m',
      \ }

call g:watchdogs#setup(g:quickrun_config)

" plugin/plug-neomake.vim
scriptencoding utf-8
if !exists("g:plugs['neomake']") | finish | endif

" ============================================================================
" neomake config
" ============================================================================

augroup dkoneomake
  autocmd!
  autocmd BufWritePost * Neomake
augroup END

"let g:neomake_verbose = 3

" loclist
let g:neomake_open_list   = 2
let g:neomake_list_height = g:dko_loc_list_height

" aggregate errors
let g:neomake_serialize   = 1

" ----------------------------------------------------------------------------
" Define linters
" ----------------------------------------------------------------------------

" Custom linters for js based on rc file presence in project dir
" Need to set the var on the hook BufReadPre, BufWinEnter is too late
" So caveat is that we can't catch when ft is set by modeline
" autocmd dkoneomake BufReadPre  *.js
"       \ let g:neomake_javascript_enabled_makers = dkoproject#JsLinters()


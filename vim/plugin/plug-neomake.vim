" plugin/plug-neomake.vim
scriptencoding utf-8
if !exists("g:plugs['neomake']") | finish | endif

augroup dkoneomake
  autocmd!
augroup END

" ============================================================================
" Output
" ============================================================================

"let g:neomake_verbose = 3

" No output on :wq
" @see https://github.com/benekastah/neomake/issues/309
" @see https://github.com/benekastah/neomake/issues/329
autocmd dkoneomake QuitPre * let g:neomake_verbose = 0

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

let g:neomake_error_sign = {
      \   'text':   '⚑',
      \   'texthl': 'SyntasticErrorSign',
      \ }

let g:neomake_warning_sign = {
      \   'text':   '⚑',
      \   'texthl': 'SyntasticWarningSign',
      \ }

" ============================================================================
" Define makers
" ============================================================================

" Custom linters for js based on rc file presence in project dir
" Need to set the var on the hook BufReadPre, BufWinEnter is too late
" So caveat is that we can't catch when ft is set by modeline
" autocmd dkoneomake BufReadPre  *.js
"       \ let g:neomake_javascript_enabled_makers = dkoproject#JsLinters()

" ----------------------------------------------------------------------------
" Maker: phpcs
" ----------------------------------------------------------------------------

function! s:SetPhpcsStandard()
  " WordPress VIP?
  if expand('%:p') =~? 'wp-\|plugins\|themes'
    let b:neomake_php_phpcs_args = neomake#makers#ft#php#phpcs().args
          \ + [ '--standard=WordPress-VIP' ]
  endif
endfunction
autocmd dkoneomake FileType php call s:SetPhpcsStandard()

" ----------------------------------------------------------------------------
" Maker: phpmd
" ----------------------------------------------------------------------------

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
autocmd dkoneomake FileType php call s:SetPhpmdRuleset()

" ============================================================================
" Auto run
" Keep this last so all the other autocmds happen first
" ============================================================================

autocmd dkoneomake BufWritePost  *   Neomake
autocmd dkoneomake Filetype      *   Neomake


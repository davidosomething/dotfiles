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
" Maker: eslint
" ----------------------------------------------------------------------------

function! s:SetupEslint()
  " Use local bin
  let l:bin = dkoproject#GetProjectConfigFile('node_modules/.bin/eslint')
  if !empty(l:bin)
    let b:neomake_javascript_eslint_exe = l:bin
  endif
endfunction
autocmd dkoneomake FileType javascript call s:SetupEslint()

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

" ----------------------------------------------------------------------------
" Maker: sasslint
" ----------------------------------------------------------------------------

let g:neomake_scss_sasslint_maker = {
      \   'exe':          'sass-lint',
      \   'args':         [ '--no-exit', '--verbose', '--format=compact' ],
      \   'errorformat':  '%E%f: line %l\, col %c\, Error - %m,' .
      \                   '%W%f: line %l\, col %c\, Warning - %m',
      \ }

function! s:SetupSasslint()
  " Use local bin
  let l:bin = dkoproject#GetProjectConfigFile('node_modules/.bin/sass-lint')
  if !empty(l:bin)
    let b:neomake_scss_sasslint_exe = l:bin
  endif

  " Use local config
  let l:config = dkoproject#GetProjectConfigFile('.sass-lint.yml')
  if !empty(l:config)
    let b:neomake_scss_sasslint_args = g:neomake_scss_sasslint_maker.args
          \ + [ '--config=' . l:config ]
  endif
endfunction
autocmd dkoneomake FileType scss call s:SetupSasslint()

" ============================================================================
" Disable makers
" ============================================================================

" using syntastic still
let g:neomake_markdown_enabled_makers   = []
let g:neomake_python_enabled_makers     = []
let g:neomake_sh_enabled_makers         = []

" limit to only preferred
let g:neomake_javascript_enabled_makers = [ 'eslint' ]
let g:neomake_scss_enabled_makers       = [ 'sasslint' ]

" ============================================================================
" Auto run
" Keep this last so all the other autocmds happen first
" ============================================================================

autocmd dkoneomake BufWritePost  *   Neomake
autocmd dkoneomake Filetype      *   Neomake


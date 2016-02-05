" ftplugin/php.vim
"
" Vars that need to be set early
"

" PHP indent settings for distributed $VIMRUNTIME/indent/php.vim
let g:PHP_outdentphpescape = 0

" ============================================================================
" syntastic: jscs if has .jscsrc
" ============================================================================

" ============================================================================
" Set phpmd ruleset for current buffer
" ============================================================================

if exists("g:plugs['syntastic']")
  let s:ruleset = dkoproject#GetProjectConfigFile('ruleset.xml')
  if !empty(s:ruleset)
    let b:syntastic_php_phpmd_post_args = s:ruleset
  endif
endif

" ============================================================================
" Set phpcs standard for current buffer
" ============================================================================

if exists("g:plugs['syntastic']")
  " WordPress?
  if match(expand('%:p'), 'wp-\|plugins\|themes') > -1
    let b:syntastic_php_phpcs_args = '--standard=WordPress-VIP'
  endif
endif


" plugin/editorconfig.vim
"
" Settings for editorconfig plugins
" Still haven't found a perfect one:
"
" - Would prefer straight up VimL for portability (sgur/vim-editorconfig)
" - Able to exclude buffer types (official editorconfig-vim)
" - Easy to add support for new props via config only (dahu/)
"

" ============================================================================
" sgur's VimL version
" Not used -- how do I disabled based on buffer name?
" @see https://github.com/sgur/vim-editorconfig/issues/7
" ============================================================================

if dko#IsPlugged('vim-editorconfig')
  let g:editorconfig_verbose = 1
endif

" ============================================================================
" Official version (python dep)
" ============================================================================

if dko#IsPlugged('editorconfig-vim')
  " Disable plugin's setting for &colorcolumn, prefer &tw relative setting
  let g:EditorConfig_max_line_indicator = ''

  let g:EditorConfig_exclude_patterns = [
        \   'fugitive://.*',
        \   'gita:.*',
        \   'scp://.*',
        \ ]
endif


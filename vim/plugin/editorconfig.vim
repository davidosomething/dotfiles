" plugin/editorconfig.vim
"
" Settings for editorconfig plugins

" ============================================================================
" sgur's VimL version
" ============================================================================

if dko#IsPlugged('vim-editorconfig')
  let g:editorconfig_verbose = 1
  finish
endif

" ============================================================================
" Official version (python dep)
" ============================================================================

if dko#IsPlugged('editoconfig-vim')
  " Disable plugin's setting for &colorcolumn, prefer &tw relative setting
  let g:EditorConfig_max_line_indicator = ''

  let g:EditorConfig_exclude_patterns = [
        \   'fugitive://.*',
        \   'gita:.*',
        \   'scp://.*',
        \ ]
endif

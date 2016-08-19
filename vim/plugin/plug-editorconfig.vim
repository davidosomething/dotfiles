" plugin/plug-editorconfig.vim

" ============================================================================
" sgur's VimL version
" ============================================================================

if exists("g:plugs['vim-editorconfig']")
  let g:editorconfig_verbose = 1
endif

" ============================================================================
" Python version
" ============================================================================

if exists("g:plugs['editorconfig-vim']")
  " Disable plugin's setting for &colorcolumn, prefer &tw relative setting
  let g:EditorConfig_max_line_indicator = ''

  let g:EditorConfig_exclude_patterns = [
        \   'fugitive://.*',
        \   'gita:.*',
        \   'scp://.*',
        \ ]
endif


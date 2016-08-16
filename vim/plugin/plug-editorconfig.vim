" plugin/plug-editorconfig.vim

" VimL version
if exists("g:plugs['vim-editorconfig']")
  let g:editorconfig_verbose = 1
endif

" Python version
if exists("g:plugs['editorconfig-vim']")
  let g:EditorConfig_exclude_patterns = [
        \   'fugitive://.*',
        \   'gita:.*',
        \   'scp://.*',
        \ ]
endif


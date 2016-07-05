" plugin/plug-editorconfig.vim

if exists("g:plugs['vim-editorconfig']")
  let g:editorconfig_verbose = 1
endif

if exists("g:plugs['editorconfig-vim']")
  let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
endif


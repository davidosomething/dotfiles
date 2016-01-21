" plugin/plug-editorconfig.vim
"
" There's two versions of the plugin -- one uses python, the other uses VimL
"

if exists("g:plugs['vim-editorconfig']")

  let g:editorconfig_verbose = 1

elseif exists("g:plugs['editorconfig-vim']")

  let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

endif


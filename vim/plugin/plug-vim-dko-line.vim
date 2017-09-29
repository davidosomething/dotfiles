" plugin/plug-vim-dko-line.vim

if !dkoplug#plugins#Exists('vim-dko-fzf') | finish | endif

execute dko#MapAll({ 'key': '<F11>', 'command': 'call dkoline#ToggleTabline()' })

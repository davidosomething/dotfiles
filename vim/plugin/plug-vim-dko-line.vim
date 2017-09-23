" plugin/plug-vim-dko-line.vim

if !dko#IsPlugged('vim-dko-fzf') | finish | endif

execute dko#MapAll({ 'key': '<F11>', 'command': 'call dkoline#ToggleTabline()' })

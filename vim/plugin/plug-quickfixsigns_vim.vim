" plugin/plug-quickfixsigns_vim.vim

if !dko#IsPlugged('quickfixsigns_vim') | finish | endif

let g:quickfixsigns_balloon = 0

" Must be recursive maps
execute dko#MapAll({
      \   'key':      '<F9>',
      \   'command':  'QuickfixsignsToggle',
      \ })


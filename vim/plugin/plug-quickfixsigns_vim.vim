" plugin/plug-quickfixsigns_vim.vim

if !dko#IsPlugged('quickfixsigns_vim') | finish | endif

let g:quickfixsigns_balloon = 0

" Leave neomake signs alone
if dko#IsPlugged('neomake')
  let g:quickfixsigns_protect_sign_rx = '^neomake_'
endif

" Must be recursive maps
execute dko#MapAll({
      \   'key':      '<F9>',
      \   'command':  'QuickfixsignsToggle',
      \ })


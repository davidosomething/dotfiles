" plugin/plug-quickfixsigns_vim.vim

if !dko#IsLoaded('quickfixsigns_vim') | finish | endif

let g:quickfixsigns_balloon = 0

"disabled:
" - 'breakpoints'
" - 'qfl' -- neomake handles
" - 'loc' -- neomake handles
let g:quickfixsigns_classes = [ 'marks', 'vcsdiff' ]

" Leave neomake signs alone
if dko#IsLoaded('neomake')
  let g:quickfixsigns_protect_sign_rx = '^neomake_'
endif

" Must be recursive maps
execute dko#MapAll({
      \   'key':      '<F9>',
      \   'command':  'QuickfixsignsToggle',
      \ })


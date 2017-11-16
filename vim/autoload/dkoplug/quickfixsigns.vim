function! dkoplug#quickfixsigns#Setup() abort
  let g:quickfixsigns_balloon = 0
  let g:quickfixsigns#vcsdiff#use_hidef = 0

  "disabled:
  " - 'breakpoints'
  " - 'qfl' -- neomake/languageclient
  " - 'loc' -- neomake/languageclient
  let g:quickfixsigns_classes = [ 'marks' ]
  if !dkoplug#Exists('vim-gitgutter')
        \&& !dkoplug#Exists('vim-signify')
    let g:quickfixsigns_classes += [ 'vcsdiff' ]
  endif

  " Leave neomake signs alone
  if dkoplug#IsLoaded('neomake')
    let g:quickfixsigns_protect_sign_rx = '^neomake_'
  endif

  " Must be recursive maps
  execute dko#MapAll({
        \   'key':      '<F9>',
        \   'command':  'QuickfixsignsToggle',
        \ })
endfunction

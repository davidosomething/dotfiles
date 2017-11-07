" plugin/signs.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

" plugin/plug-quickfixsigns_vim.vim
if dkoplug#plugins#IsLoaded('quickfixsigns_vim')
  let g:quickfixsigns_balloon = 0
  let g:quickfixsigns#vcsdiff#use_hidef = 0

  "disabled:
  " - 'breakpoints'
  " - 'qfl' -- neomake/languageclient
  " - 'loc' -- neomake/languageclient
  let g:quickfixsigns_classes = [ 'marks' ]
  if !dkoplug#plugins#Exists('vim-gitgutter')
        \&& !dkoplug#plugins#Exists('vim-signify')
    let g:quickfixsigns_classes += [ 'vcsdiff' ]
  endif

  " Leave neomake signs alone
  if dkoplug#plugins#IsLoaded('neomake')
    let g:quickfixsigns_protect_sign_rx = '^neomake_'
  endif

  " Must be recursive maps
  execute dko#MapAll({
        \   'key':      '<F9>',
        \   'command':  'QuickfixsignsToggle',
        \ })
endif

if dkoplug#plugins#Exists('vim-gitgutter')
  " Don't touch my colors
  let g:gitgutter_override_sign_column_highlight = 0

  " Don't touch my keys
  let g:gitgutter_map_keys = 0

  nmap [c <Plug>GitGutterPrevHunk
  nmap ]c <Plug>GitGutterNextHunk

  omap ic <Plug>GitGutterTextObjectInnerPending
  omap ac <Plug>GitGutterTextObjectOuterPending
  xmap ic <Plug>GitGutterTextObjectInnerVisual
  xmap ac <Plug>GitGutterTextObjectOuterVisual

elseif dkoplug#plugins#Exists('vim-signify')
  let g:signify_vcs_list = [ 'git' ]
  let g:signify_sign_change = '·'
  let g:signify_sign_show_count = 0 " don't show number of deleted lines
  let g:signify_realtime = 0
endif

let &cpoptions = s:cpo_save
unlet s:cpo_save

function! dkoplug#gitgutter#Setup() abort
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
endfunction

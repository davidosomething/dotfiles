" plugin/clipboard.vim

" ======================================================================
" EasyClip
" ======================================================================

if dkoplug#IsLoaded('vim-easyclip')
  " explicitly do NOT remap s/S to paste register
  let g:EasyClipUseSubstituteDefaults = 0
  " Don't override pastetoggle
  let g:EasyClipUseGlobalPasteToggle = 0

else
  call dko#blackhole#Map()

endif

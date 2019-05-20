" plugin/plug-vim-signature.vim
scriptencoding utf-8

" ============================================================================
" vim-signature for marks
" ============================================================================

if dkoplug#IsLoaded('vim-signature')
  " disable mappings
  let g:SignatureMap = {
        \   'Leader': 'm',
        \   'PlaceNextMark': '',
        \   'ToggleMarkAtLine': '',
        \   'PurgeMarksAtLine': 'M',
        \   'DeleteMark': '',
        \   'PurgeMarks': 'gM',
        \   'PurgeMarkers': '',
        \   'GotoNextLineAlpha': '',
        \   'GotoPrevLineAlpha': '',
        \   'GotoNextSpotAlpha': '',
        \   'GotoPrevSpotAlpha': '',
        \   'GotoNextLineByPos': '',
        \   'GotoPrevLineByPos': '',
        \   'GotoNextSpotByPos': ']`',
        \   'GotoPrevSpotByPos': '[`',
        \   'GotoNextMarker': '',
        \   'GotoPrevMarker': '',
        \   'GotoNextMarkerAny': '',
        \   'GotoPrevMarkerAny': '',
        \   'ListBufferMarks': '',
        \   'ListBufferMarkers': '',
        \ }
endif

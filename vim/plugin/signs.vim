" plugin/signs.vim
scriptencoding utf-8

let s:cpo_save = &cpoptions
set cpoptions&vim

if dkoplug#IsLoaded('vim-signature')
  " disable mappings
  let g:SignatureMap = {
        \   'Leader': '<Leader>gm',
        \   'PlaceNextMark': '',
        \   'ToggleMarkAtLine': '',
        \   'PurgeMarksAtLine': '',
        \   'DeleteMark': '',
        \   'PurgeMarks': '',
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

elseif dkoplug#IsLoaded('quickfixsigns_vim')
  call dkoplug#quickfixsigns#Setup()
endif

if dkoplug#Exists('vim-gitgutter')
  call dkoplug#gitgutter#Setup()

elseif dkoplug#Exists('vim-signify')
  let g:signify_vcs_list = [ 'git' ]
  let g:signify_sign_change = '·'
  let g:signify_sign_show_count = 0 " don't show number of deleted lines
  let g:signify_realtime = 0
endif

let &cpoptions = s:cpo_save
unlet s:cpo_save

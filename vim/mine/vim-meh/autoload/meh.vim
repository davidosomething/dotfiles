" These bar colors apply to all colorschemes
" So after switching to a non-meh colorscheme, you can call this function to
" keep the meh status and tab line colors
function! meh#LineColors() abort
  " ============================================================================
  " Status and tab line
  " ============================================================================

  hi! dkoStatus           guibg=#30313c guifg=#aaaaaa gui=NONE  ctermbg=237
  hi! dkoStatusNC         guibg=#262631 guifg=#666666 gui=NONE  ctermbg=235
  hi! dkoStatusKey        guibg=#40404c
  hi! dkoStatusValue      guibg=#50505c
  hi! dkoStatusItem       guibg=#242531
  hi! dkoStatusTransient  guibg=#505a71 guifg=fg
  hi! dkoStatusGood       guibg=#242531 guifg=#77aa88
  hi! dkoStatusError      guibg=#242531 guifg=#cc4444
  hi! dkoStatusWarning    guibg=#242531 guifg=#ddaa66
  hi! dkoStatusInfo       guibg=#242531 guifg=fg

  " Statusline uses fg as bg
  hi! link StatusLineNC   dkoStatusNC
  hi! link StatusLine     dkoStatus
  hi! link TabLine        dkoStatus
  hi! link TabLineFill    dkoStatus
  hi! link TabLineSel     dkoStatus

  " ============================================================================
  " Statusline Symbols
  " ============================================================================

  hi! dkoLineImportant    guibg=#ddaa66 guifg=#303033
  hi! link dkoLineModeReplace       dkoLineImportant
  hi! link dkoLineNeomakeRunning    dkoLineImportant

  " ============================================================================
  " Neomake
  " ============================================================================

  hi! link NeomakeStatusGood      dkoStatusGood

  " ============================================================================
  " Sign column
  " ============================================================================

  " kshenoy/vim-signature
  hi! link SignatureMarkText        dkoLineImportant

  " showmarks
  hi! link ShowMarksHLl             dkoLineImportant
  hi! link ShowMarksHLu             dkoLineImportant
endfunction

" vim-pandoc colors load out of normal colorscheme order, this fn helps
" override
function! meh#PandocColors() abort
  hi! link pandocAtxHeader                Function
  hi! link pandocAtxStart                 dkoDecorations
  hi! link pandocAutomaticLink            Underlined
  hi! link pandocBlockQuote               dkoQuote
  hi! link pandocDelimitedCodeBlockStart  Normal
  hi! link pandocDelimitedCodeBlock       String
  hi! link pandocDelimitedCodeBlockEnd    Normal
  hi! link pandocHRule                    dkoDecorations
  hi! link pandocPipeTableDelims          dkoDecorations
  hi! link pandocReferenceURL             Underlined
  hi! link pandocUListItemBullet          Normal
endfunction

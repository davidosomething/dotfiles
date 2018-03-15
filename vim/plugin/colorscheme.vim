" plugin/colorscheme.vim

let s:cpo_save = &cpoptions
set cpoptions&vim

augroup dkocolorscheme
  autocmd!
augroup END

" ============================================================================

let s:truecolor = exists('+termguicolors')
      \ && $TERM_PROGRAM !=# 'Apple_Terminal'
if s:truecolor | let &termguicolors = 1 | endif

let s:colorscheme = 'darkblue'

if dkoplug#Exists('nord-vim')
  let g:nord_italic_comments = 1
endif

if dkoplug#Exists('vim-two-firewatch')
  function! s:Firewatch() abort
    silent! colorscheme two-firewatch
  endfunction
  nnoremap <silent><special> <Leader>zt :<C-U>call <SID>Firewatch()<CR>:set bg=light<CR>

  let s:colorscheme = s:truecolor && $ITERM_PROFILE =~? 'light'
        \ ? 'two-firewatch'
        \ : s:colorscheme
endif

let s:colorscheme = s:truecolor || $TERM_PROGRAM =~? 'Hyper'
      \ ? 'dko'
      \ : s:colorscheme
nnoremap <silent><special> <Leader>zd :<C-U>silent! colorscheme dko<CR>

" These bar colors apply to all colorschemes
function! s:LineColors() abort
  " ============================================================================
  " Status and tab line
  " ============================================================================

  hi! dkoStatus           guibg=#30313c guifg=#aaaaaa gui=NONE
  hi! dkoStatusNC         guibg=#262631 guifg=#666666 gui=NONE
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
endfunction
if s:truecolor
  autocmd dkocolorscheme ColorScheme * call s:LineColors()
endif

autocmd dkocolorscheme VimEnter * nested silent! execute 'colorscheme ' . s:colorscheme
"autocmd dkocolorscheme VimEnter * colorscheme dko

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

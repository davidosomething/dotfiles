scriptencoding utf-8

" ============================================================================
" My abbreviations and autocorrect
" ============================================================================

inoreabbrev :lod: ಠ_ಠ
inoreabbrev :flip: (ﾉಥ益ಥ）ﾉ︵┻━┻
inoreabbrev :yuno: ლ(ಠ益ಠლ)

inoreabbrev targetted targeted
inoreabbrev targetting targeting

" ============================================================================
" Not-quite-abbreviations
" ============================================================================

" insert date, e.g. 2015-02-19
inoremap <Leader>:d <Esc>"=strftime("%Y-%m-%d")<CR>Pa

" insert file dir
inoremap <Leader>:fd <C-R>=expand('%:h')<CR>

" insert file name
inoremap <Leader>:fn <C-R>=expand('%:t')<CR>

" insert full filepath
inoremap <Leader>:fp <C-R>=expand('%:p:h')<CR>


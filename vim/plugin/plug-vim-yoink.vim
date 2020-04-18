" plugin/plug-vim-yoink.vim

if !dkoplug#IsLoaded('vim-yoink') | finish | endif

let g:yoinkIncludeDeleteOperations = 1
let g:yoinkSyncSystemClipboardOnFocus = 0

let s:cpo_save = &cpoptions
set cpoptions&vim

nmap <special> <c-n> <plug>(YoinkPostPasteSwapForward)
nmap <special> <c-p> <plug>(YoinkPostPasteSwapBack)

nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

let &cpoptions = s:cpo_save
unlet s:cpo_save

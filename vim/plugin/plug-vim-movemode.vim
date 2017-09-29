" plugin/plug-vim-movemode.vim

if !dkoplug#plugins#Exists('vim-movemode') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

nnoremap  <special>   <Leader>mm  :<C-U>call movemode#toggle()<CR>

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

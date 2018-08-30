" plugin/plug-vim-smallcaps.vim

if !dkoplug#Exists('vim-smallcaps') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

augroup dkovimmovemode
  autocmd!
  autocmd BufEnter * if dko#IsEditable('%')
        \| vmap <special> <Leader>C <Plug>(dkosmallcaps)
        \| endif
augroup END

let &cpoptions = s:cpo_save
unlet s:cpo_save

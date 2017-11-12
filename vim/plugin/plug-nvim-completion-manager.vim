" plugin/plug-nvim-completion-manager.vim

augroup dkoncm
  autocmd!
  " autocmd dkoncm User CmBefore  echomsg 'nvim-completion-manager loading'
  " autocmd dkoncm User CmSetup   echomsg 'nvim-completion-manager loaded'
augroup END

if !dkoplug#Exists('nvim-completion-manager') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

let g:cm_refresh_length = [
      \   [1, 4],
      \   [7, 2],
      \ ]

" Delay loading NCM until InsertEnter
function s:StartNcm()
  " Hooks for setting up sources before loading NCM
  silent! doautocmd User CmBefore
  call plug#load('nvim-completion-manager')
  autocmd! dkoncm InsertEnter
endfunction
autocmd dkoncm InsertEnter * call s:StartNcm()

" Refresh list
imap <special><expr> <C-g> pumvisible()
      \ ? "\<Plug>(cm_force_refresh)"
      \ : "\<C-g>"

let &cpoptions = s:cpo_save
unlet s:cpo_save

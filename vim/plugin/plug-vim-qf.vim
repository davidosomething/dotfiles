" plugin/plug-vim-qf.vim

if !dkoplug#Exists('vim-qf') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

nmap [l <Plug>qf_loc_previous
nmap ]l <Plug>qf_loc_next
nmap [q <Plug>qf_qf_previous
nmap ]q <Plug>qf_qf_next

let &cpoptions = s:cpo_save
unlet s:cpo_save

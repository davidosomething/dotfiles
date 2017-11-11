" plugin/plug-vim-qf.vim

if !dkoplug#plugins#Exists('vim-qf') | finish | endif

nmap [l <Plug>qf_loc_previous
nmap ]l <Plug>qf_loc_next
nmap [q <Plug>qf_qf_previous
nmap ]q <Plug>qf_qf_next

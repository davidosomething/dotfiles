" plugin/plug-vim-gutentags.vim

if !dko#IsPlugged('vim-hier') | finish | endif

let g:hier_enabled = 0
let g:hier_highlight_group_qf = 'Error'
let g:hier_highlight_group_qfw = 'Error'
let g:hier_highlight_group_qfi = 'Error'

let g:hier_highlight_group_loc = 'Error'
let g:hier_highlight_group_locw = 'Error'
let g:hier_highlight_group_loci = 'Error'

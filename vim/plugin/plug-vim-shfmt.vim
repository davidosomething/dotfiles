" plugin/plug-vim-shfmt.vim

if !dko#IsLoaded('vim-shfmt') | finish | endif
let g:shfmt_switches = ['-i 2']

" plugin/plug-committia.vim

if !exists("g:plugs['committia.vim']") | finish | endif

let g:committia_open_only_vim_starting = 0
let g:committia_use_singlecolumn       = 'always'

augroup dkocommittia
  autocmd!
augroup END

" autocmd dkocommittia
"       \ BufNewFile,BufReadPost **/{MERGE_,TAG_EDIT,}MSG
"       \ call committia#open('git')


" plugin/plug-vim-indent-guides.vim

augroup dkoindentguides
  autocmd!
augroup END

if !dkoplug#IsLoaded('vim-indent-guides') | finish | endif

" added custom colors to my colorscheme
let g:indent_guides_auto_colors = 0
let g:indent_guides_color_change_percent = 10

" The autocmd hooks are run after plugins loaded so okay to reference them in
" this file even though it is sourced before the functions are defined.
autocmd dkoindentguides BufEnter
      \ *.block,*.hbs,*.html,*.mustache,*.php
      \ IndentGuidesEnable
autocmd dkoindentguides BufLeave
      \ *.block,*.hbs,*.html,*.mustache,*.php
      \ IndentGuidesDisable

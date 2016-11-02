" plugin/plug-vim-indent-guides.vim
if !dko#IsPlugged('vim-indent-guides') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

let g:indent_guides_color_change_percent = 3

" The autocmd hooks are run after plugins loaded so okay to reference them in
" this file even though it is sourced before the functions are defined.
augroup dkoindentguides
  autocmd!
  autocmd BufEnter  *.hbs,*.html,*.mustache,*.php   IndentGuidesEnable
  autocmd BufLeave  *.hbs,*.html,*.mustache,*.php   IndentGuidesDisable
augroup END

" Must be recursive maps
execute dko#MapAll({
      \   'key':      '<F10>',
      \   'command':  'IndentGuidesToggle',
      \ })

let s:cpo_save = &cpoptions
set cpoptions&vim


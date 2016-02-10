" plugin/plug-vim-indent-guides.vim
if !exists("g:plugs['vim-indent-guides']") | finish | endif

let g:indent_guides_color_change_percent = 3

" The autocmd hooks are run after plugins loaded so okay to reference them in
" this file even though it is sourced before the functions are defined.
augroup dkoindentguides
  autocmd!
  autocmd BufEnter  *.hbs,*.html,*.mustache,*.php   IndentGuidesEnable
  autocmd BufLeave  *.hbs,*.html,*.mustache,*.php   IndentGuidesDisable
augroup END

" Must be recursive maps
nmap  <special>   <F11>   <Plug>IndentGuidesToggle
" keep cursor position
imap  <special>   <F11>   <Esc>:<C-u>IndentGuidesToggle<CR>a


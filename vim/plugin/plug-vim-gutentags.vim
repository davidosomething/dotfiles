" plugin/plug-vim-gutentags.vim
if !dko#IsPlugged('vim-gutentags') | finish | endif

let g:gutentags_tagfile = '.git/tags'

" Toggle :GutentagsToggleEnabled to enable
let g:gutentags_enabled                  = 0
let g:gutentags_define_advanced_commands = 1
let g:gutentags_resolve_symlinks         = 1

" Special user autocmd from my fork
augroup dkogutentags
  autocmd!
  autocmd User GutentagsUpdated redraw!
augroup END


" plugin/plug-vim-gutentags.vim

if !dko#IsPlugged('vim-gutentags') | finish | endif

let g:gutentags_ctags_tagfile = '.git/tags'

" Toggle :GutentagsToggleEnabled to enable
let g:gutentags_enabled                  = 1
let g:gutentags_generate_on_missing      = 0
let g:gutentags_generate_on_new          = 0
let g:gutentags_generate_on_write        = 1
let g:gutentags_define_advanced_commands = 1
let g:gutentags_resolve_symlinks         = 1

" When these markers are present, use these commands to get list of files that
" tags need to be generated for
let g:gutentags_file_list_command = {
      \   'markers': {
      \     '.git': 'git ls-files',
      \     '.hg': 'hg files',
      \   },
      \ }

" Special user autocmd from my fork
augroup dkogutentags
  autocmd!
  autocmd User GutentagsUpdated redraw!
augroup END


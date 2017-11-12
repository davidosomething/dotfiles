" plugin/plug-vim-editorconfig.vim
" sgur/vim-editorconfig

if !dkoplug#IsLoaded('vim-editorconfig') | finish | endif

let g:editorconfig_verbose = 1

augroup dkovimeditorconfig
  autocmd!

  " Always load editorconfig upon opening a file
  " default skips new files in non-existent directories
  " see https://github.com/sgur/vim-editorconfig/issues/17
  autocmd BufNewFile,BufReadPost * nested call editorconfig#load()

  " nvim-completion-manager omnifunc setup
  autocmd User CmSetup call cm#register_source({
        \   'name':                 'cm-editorconfig',
        \   'priority':             9,
        \   'scoping':              1,
        \   'scopes':               [ 'editorconfig' ],
        \   'abbreviation':         'editorconfig',
        \   'word_pattern':         '[\w\-]+',
        \   'cm_refresh_patterns':  ['[\w\-]+\s*:\s+'],
        \   'cm_refresh':           { 'omnifunc': 'editorconfig#omnifunc' },
        \ })
augroup END

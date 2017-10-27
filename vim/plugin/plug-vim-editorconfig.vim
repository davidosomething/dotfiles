" plugin/plug-vim-editorconfig.vim
" sgur/vim-editorconfig

if !dkoplug#plugins#IsLoaded('vim-editorconfig') | finish | endif

let g:editorconfig_verbose = 1

augroup dkovimeditorconfig
  autocmd!
  " Always load editorconfig upon opening a file
  autocmd BufNewFile,BufReadPost * nested call editorconfig#load()

  " editorconfig directive completion via `csscomplete#CompleteCSS`
  " The `'cm_refresh_patterns'` is PCRE.
  " Be careful with `'scoping': 1` here, not all sources, especially omnifunc,
  " can handle this feature properly.
  au User CmSetup call cm#register_source({
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

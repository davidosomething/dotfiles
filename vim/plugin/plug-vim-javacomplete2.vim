" plugin/plug-vim-javacomplete2.vim

if !dkoplug#Exists('vim-javacomplete2') | finish | endif

augroup dkojavacomplete
  autocmd!
  autocmd FileType java
        \ setlocal omnifunc=javacomplete#Complete

  autocmd User CmSetup call cm#register_source({
        \   'name':                'cm-java',
        \   'priority':            6,
        \   'scoping':             0,
        \   'scopes':              ['java'],
        \   'abbreviation':        'java',
        \   'word_pattern':        '[\w\-]+',
        \   'cm_refresh_patterns': ['[\w\-]+\s*:\s+'],
        \   'cm_refresh':          { 'omnifunc': 'javacomplete#Complete' },
        \ })
augroup END

let g:JavaComplete_ClosingBrace = 0
let g:JavaComplete_ShowExternalCommandsOutput = 1

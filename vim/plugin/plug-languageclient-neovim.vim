" plugin/plug-languageclient-neovim.vim

if !dko#IsLoaded('LanguageClient-neovim') | finish | endif

augroup dkolanguageclient
  autocmd!
augroup END

" Autostarted in LanguageClient-neovim
if dko#IsLoaded('roxma/LanguageServer-php-neovim')
  autocmd dkolanguageclient FileType javascript LanguageClientStart
  autocmd dkolanguageclient FileType php        LanguageClientStart
endif

let g:LanguageClient_serverCommands = {}
"\ 'rust': ['rustup', 'run', 'nightly', 'rls'],

let s:langserver_js = glob('~/src/javascript-typescript-langserver/lib/language-server-stdio.js')
if !empty(s:langserver_js)
  let g:LanguageClient_serverCommands.javascript = [ s:langserver_js ]
endif

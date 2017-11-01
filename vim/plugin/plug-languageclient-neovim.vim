" plugin/plug-languageclient-neovim.vim

if !dkoplug#plugins#IsLoaded('LanguageClient-neovim') | finish | endif

augroup dkolanguageclient
  autocmd!
augroup END

let g:LanguageClient_autoStart = 1
let g:LanguageClient_diagnosticsList = 'location' " use loclist instead of qf
let g:LanguageClient_serverCommands = {}

" Disabled for now
if 0 && executable('flow-language-server')
  let g:LanguageClient_serverCommands['javascript'] = [
        \   'flow-language-server',
        \   '--stdio'
        \ ]
elseif g:dko_use_js_langserver
  let g:LanguageClient_serverCommands['javascript'] = [
        \   'javascript-typescript-stdio'
        \ ]
endif

" plugin/plug-languageclient-neovim.vim

if !dko#IsLoaded('LanguageClient-neovim') | finish | endif

augroup dkolanguageclient
  autocmd!
augroup END

let g:LanguageClient_serverCommands = {}

if executable('flow-language-server')
  let g:LanguageClient_serverCommands['javascript'] = [
        \   'flow-language-server',
        \   '--stdio'
        \ ]
endif

" Autostarted in LanguageClient-neovim
if dko#IsPlugged('roxma/LanguageServer-php-neovim')
  autocmd dkolanguageclient FileType php LanguageClientStart
endif

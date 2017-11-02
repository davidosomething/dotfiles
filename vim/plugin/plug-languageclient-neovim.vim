" plugin/plug-languageclient-neovim.vim

if !dkoplug#plugins#IsLoaded('LanguageClient-neovim') | finish | endif

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

let s:cpo_save = &cpoptions
set cpoptions&vim

nnoremap <silent> <Leader>d
      \ :<C-u>call LanguageClient_textDocument_definition()<CR>

nnoremap <silent> <leader>k
      \ :<C-u>call LanguageClient_textDocument_hover()<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save

" plugin/plug-languageclient-neovim.vim

if !dkoplug#IsLoaded('LanguageClient-neovim') | finish | endif

" ============================================================================
" Plugin settings
" ============================================================================

let g:LanguageClient_autoStart = executable(
      \ g:plugs['LanguageClient-neovim']['dir'] . 'bin/languageclient'
      \ )
let g:LanguageClient_loggingLevel = 'INFO'
" Don't populate lists since it overrides Neomake lists
let g:LanguageClient_diagnosticsList = 'Quickfix'
let g:LanguageClient_serverCommands = {}

" ============================================================================
" Mappings
" ============================================================================

let s:cpo_save = &cpoptions
set cpoptions&vim

nnoremap <silent> <Leader>d
      \ :<C-u>call LanguageClient_textDocument_definition()<CR>

nnoremap <silent> <leader>k
      \ :<C-u>call LanguageClient_textDocument_hover()<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save

" ============================================================================
" Language Server Setup
" ============================================================================

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
  let g:LanguageClient_serverCommands['typescript'] =
        \ g:LanguageClient_serverCommands['javascript']
endif

" @TODO
" python pyls
" lua lua-lsp
" go go-langserver

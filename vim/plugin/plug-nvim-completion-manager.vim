" plugin/plug-nvim-completion-manager.vim

if !dko#IsPlugged('nvim-completion-manager') | finish | endif

augroup dkonvimcompletionmanager
  autocmd!
augroup END

if dko#IsPlugged('deoplete.nvim')
  " register deoplete as ncm source
  autocmd dkonvimcompletionmanager User CmSetup
        \ call cm#register_source({
        \   'name': 'deoplete',
        \   'priority': 7,
        \   'abbreviation': '',
        \ })

  " forward to ncm
  function! g:Deoplete_ncm() abort
    call cm#complete(
          \   'deoplete',
          \   cm#context(),
          \   g:deoplete#_context.complete_position + 1,
          \   g:deoplete#_context.candidates
          \ )
    return ''
  endfunction

  " hack deoplete's mapping
  inoremap <silent> <Plug>_ <C-r>=g:Deoplete_ncm()<CR>

endif

" Autostarted in LanguageClient-neovim
" if dko#IsPlugged('roxma/LanguageServer-php-neovim')
  " let g:LanguageClient_serverCommands = {
  "       \   'php': [
  "       \     'php',
  "       \     expand(g:dko#plug_absdir . '/vendor/felixfbecker/language-server/bin/php-language-server.php')
  "       \   ],
  "       \ }
  " autocmd dkonvimcompletionmanager FileType php LanguageClientStart
" endif

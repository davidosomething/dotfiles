" plugin/plug-languageclient-neovim.vim

if !dko#IsLoaded('LanguageClient-neovim') | finish | endif

augroup dkolanguageclient
  autocmd!
augroup END

" Autostarted in LanguageClient-neovim
if dko#IsPlugged('roxma/LanguageServer-php-neovim')
  autocmd dkolanguageclient FileType php LanguageClientStart
endif

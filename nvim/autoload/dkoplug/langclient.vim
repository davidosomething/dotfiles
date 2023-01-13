function! dkoplug#langclient#Load() abort

  " The language client completion is a bit slow to kick in, but it works
  Plug 'autozimu/LanguageClient-neovim', WithCompl({
        \   'branch': 'next',
        \   'do': 'bash ./install.sh',
        \ })

endfunction

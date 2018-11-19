function! dkoplug#ncm2#Load() abort
  " Auto-insert matching braces with detection for jumping out on close.
  " No right brace detection
  "Plug 'cohama/lexima.vim'
  " Slow but detects right brace
  "Plug 'Raimondi/delimitMate'
  " Slowest
  "Plug 'kana/vim-smartinput'

  " Main completion engine, bound to <C-o>
  " Plug 'roxma/nvim-yarp', WithCompl()
  " Plug 'ncm2/ncm2', WithCompl()
  Plug 'ncm2/ncm2-bufword', WithCompl()
  Plug 'ncm2/ncm2-path', WithCompl()

  " Complete words from other open buffers (tags is probably enough, this will
  " just introduce irrelevant completions)
  "Plug 'fgrsnau/ncm-otherbuf', WithCompl()

  " --------------------------------------------------------------------------
  " NCM functionality: Includes
  " --------------------------------------------------------------------------

  " Include completion, include tags
  " For what langs are supported, see:
  " https://github.com/Shougo/neoinclude.vim/blob/master/autoload/neoinclude.vim
  " Note: NCM Errors when can't find b:node_root (from moll/vim-node)
  Plug 'ncm2/ncm2-neoinclude', WithCompl()

  " --------------------------------------------------------------------------
  " Completion: CSS
  " --------------------------------------------------------------------------

  Plug 'ncm2/ncm2-cssomni', WithCompl()

  " --------------------------------------------------------------------------
  " Completion: Java
  " --------------------------------------------------------------------------

  " Plug 'artur-shaik/vim-javacomplete2', PlugIf(executable('mvn'), {
  "       \   'do': 'cd -- libs/javavi/ && mvn compile',
  "       \   'for': [ 'java' ],
  "       \ })

  " --------------------------------------------------------------------------
  " Completion: JavaScript
  " --------------------------------------------------------------------------

  " Plug 'ncm2/ncm2-tern', PlugIf(g:dko_use_tern_lsp, {
  "       \   'do': 'npm install --force'
  "       \ })

  " --------------------------------------------------------------------------
  " Completion: Markdown
  " --------------------------------------------------------------------------

  Plug 'ncm2/ncm2-markdown-subscope', WithCompl()

  " --------------------------------------------------------------------------
  " Completion: PHP
  " --------------------------------------------------------------------------

  " --------------------------------------------------------------------------
  " Completion: Python
  " --------------------------------------------------------------------------

  Plug 'ncm2/ncm2-jedi', WithCompl()

  " --------------------------------------------------------------------------
  " Completion: Syntax
  " --------------------------------------------------------------------------

  Plug 'ncm2/ncm2-syntax', WithCompl()

  " --------------------------------------------------------------------------
  " Completion: VimL
  " --------------------------------------------------------------------------

  Plug 'ncm2/ncm2-vim', WithCompl()
endfunction

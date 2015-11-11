" ----------------------------------------------------------------------------
" Plugin configs -------------------------------------------------------------
" ----------------------------------------------------------------------------
" Source manually to preserve source order

" Colorscheme selection ------------------------------------------------------
if g:has_true_color || has('gui_running') " neovim or gvim
  " Note that frankier/neovim-colors-solarized-truecolor-only is used for nvim

  " turn off gross italics -- fira sans happens to use ligatures too
  let g:solarized_italic = 0

  call togglebg#map("<F5>")
  colorscheme solarized
  set background=light

else " terminal vim
  silent! colorscheme base16-tomorrow
  set background=dark

endif

" Completion engine selection ------------------------------------------------
if g:dko_use_neocomplete
  source $VIM_DOTFILES/rc/neocomplete.vim
endif

if g:dko_use_tern_completion
  source $VIM_DOTFILES/rc/tern_for_vim.vim
endif

" PHP plugins ----------------------------------------------------------------
source $VIM_DOTFILES/rc/PHP-Indenting-for-VIm.vim
source $VIM_DOTFILES/rc/php.vim
source $VIM_DOTFILES/rc/phpcomplete.vim
source $VIM_DOTFILES/rc/pdv.vim

" Rest -----------------------------------------------------------------------
source $VIM_DOTFILES/rc/Cmd2.vim
source $VIM_DOTFILES/rc/airline.vim
source $VIM_DOTFILES/rc/colorv.vim
source $VIM_DOTFILES/rc/committia.vim
source $VIM_DOTFILES/rc/cosco.vim
source $VIM_DOTFILES/rc/editorconfig.vim
source $VIM_DOTFILES/rc/gundo.vim
source $VIM_DOTFILES/rc/incsearch.vim
source $VIM_DOTFILES/rc/javascript-libraries-syntax.vim
source $VIM_DOTFILES/rc/neosnippet.vim
source $VIM_DOTFILES/rc/scss-syntax.vim
source $VIM_DOTFILES/rc/smartpairs.vim
source $VIM_DOTFILES/rc/syntastic.vim
source $VIM_DOTFILES/rc/tabular.vim
source $VIM_DOTFILES/rc/unite.vim
source $VIM_DOTFILES/rc/vim-anzu.vim
source $VIM_DOTFILES/rc/vim-coffee-script.vim
source $VIM_DOTFILES/rc/vim-css3-syntax.vim
source $VIM_DOTFILES/rc/vim-easyclip.vim
source $VIM_DOTFILES/rc/vim-gutentags.vim
source $VIM_DOTFILES/rc/vim-indent-guides.vim
source $VIM_DOTFILES/rc/vim-instant-markdown.vim
source $VIM_DOTFILES/rc/vim-jsdoc.vim
source $VIM_DOTFILES/rc/vim-json.vim
source $VIM_DOTFILES/rc/vim-over.vim
source $VIM_DOTFILES/rc/vimfiler.vim

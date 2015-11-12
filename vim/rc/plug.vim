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

let g:dko_rc_dir = g:dko_vim_dir . "/rc/"

" Completion engine selection ------------------------------------------------
if g:dko_use_neocomplete | exec "source " . g:dko_rc_dir . "neocomplete.vim" | endif
if g:dko_use_deoplete | exec "source " . g:dko_rc_dir . "deoplete.vim" | endif
if g:dko_use_tern_completion | exec "source " . g:dko_rc_dir . "tern_for_vim.vim" | endif

" PHP plugins ----------------------------------------------------------------
exec "source " . g:dko_rc_dir . "PHP-Indenting-for-VIm.vim"
exec "source " . g:dko_rc_dir . "php.vim"
exec "source " . g:dko_rc_dir . "phpcomplete.vim"
exec "source " . g:dko_rc_dir . "pdv.vim"

" Rest -----------------------------------------------------------------------
exec "source " . g:dko_rc_dir . "Cmd2.vim"
exec "source " . g:dko_rc_dir . "airline.vim"
exec "source " . g:dko_rc_dir . "colorv.vim"
exec "source " . g:dko_rc_dir . "committia.vim"
exec "source " . g:dko_rc_dir . "cosco.vim"
exec "source " . g:dko_rc_dir . "editorconfig.vim"
exec "source " . g:dko_rc_dir . "gundo.vim"
if g:dko_use_incsearch | exec "source " . g:dko_rc_dir . "incsearch.vim" | endif
exec "source " . g:dko_rc_dir . "javascript-libraries-syntax.vim"
exec "source " . g:dko_rc_dir . "neosnippet.vim"
exec "source " . g:dko_rc_dir . "scss-syntax.vim"
exec "source " . g:dko_rc_dir . "smartpairs.vim"
exec "source " . g:dko_rc_dir . "syntastic.vim"
exec "source " . g:dko_rc_dir . "tabular.vim"
exec "source " . g:dko_rc_dir . "unite.vim"
exec "source " . g:dko_rc_dir . "vim-anzu.vim"
exec "source " . g:dko_rc_dir . "vim-coffee-script.vim"
exec "source " . g:dko_rc_dir . "vim-css3-syntax.vim"
exec "source " . g:dko_rc_dir . "vim-easyclip.vim"
exec "source " . g:dko_rc_dir . "vim-gutentags.vim"
exec "source " . g:dko_rc_dir . "vim-indent-guides.vim"
exec "source " . g:dko_rc_dir . "vim-instant-markdown.vim"
exec "source " . g:dko_rc_dir . "vim-jsdoc.vim"
exec "source " . g:dko_rc_dir . "vim-json.vim"
exec "source " . g:dko_rc_dir . "vim-over.vim"
exec "source " . g:dko_rc_dir . "vimfiler.vim"

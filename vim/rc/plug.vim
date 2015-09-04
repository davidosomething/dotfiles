" Load vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

let g:plug_window = 'new'

call plug#begin('~/.vim/plugged')

" Whitespace
Plug 'vim-scripts/PreserveNoEOL'
      \| Plug 'editorconfig/editorconfig-vim'

Plug 'airblade/vim-helptab'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'

" creates dir if new file in new dir
Plug 'dockyard/vim-easydir'

" show registers in tem split if use \" or <C-R>
Plug 'junegunn/vim-peekaboo'

" auto tag generation via exuberant-ctags -- no tags file created
Plug 'majutsushi/tagbar',                 { 'on': [ 'TagbarToggle' ] }
      \| Plug 'lukaszkorecki/CoffeeTags', { 'for': ['coffee'] }
      \| Plug 'vim-php/tagbar-phpctags.vim', { 'for': ['php', 'blade'], 'do': 'make' }

Plug 'nathanaelkane/vim-indent-guides'

Plug 'now/vim-quit-if-only-quickfix-buffer-left'

" Most recently used files for unite.vim -- config is in unite.vim
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
      \| Plug 'Shougo/neomru.vim'
      \| Plug 'Shougo/unite.vim'
      \| Plug 'Shougo/vimfiler.vim'

Plug 'sjl/gundo.vim',                     { 'on': [ 'GundoToggle' ] }

Plug 'suan/vim-instant-markdown',         { 'for': ['markdown'], 'do': 'npm install -g instant-markdown-d' }

Plug 'tpope/vim-fugitive'

Plug 'tyru/restart.vim',                  { 'on': [ 'Restart' ] }

Plug 'gelguy/Cmd2.vim'

Plug 'haya14busa/incsearch.vim'

Plug 'osyo-manga/vim-anzu'

Plug 'osyo-manga/vim-over',               { 'on': [ 'OverCommandLine' ] }

Plug 'tpope/vim-eunuch'

" used for line bubbling commands on osx
Plug 'tpope/vim-unimpaired'

" neocomplete probably used on osx and on my arch
" only load tern when neocomplete loads and on JS
Plug 'Shougo/neocomplete.vim'
      \| Plug 'marijnh/tern_for_vim', { 'for': ['javascript', 'typescript'], 'do': 'npm install' }

Plug 'Shougo/neosnippet'
      \| Plug 'honza/vim-snippets'
      \| Plug 'Shougo/neosnippet-snippets'

" ------------------------------------------------------------------------------
" editing keys
Plug 'godlygeek/tabular',                 { 'on': [ 'Tabularize' ] }

" viv, v, v to expand surround selection
Plug 'gorkunov/smartpairs.vim'

Plug 'rhysd/conflict-marker.vim'

Plug 'lfilho/cosco.vim'

Plug 'svermeulen/vim-easyclip'

" custom C-x C-a mappings
Plug 'nishigori/increment-activator'

Plug 'tomtom/tcomment_vim'

Plug 'tpope/vim-endwise'

Plug 'tpope/vim-repeat'

" fast increment datetimes
Plug 'tpope/vim-speeddating'

Plug 'tpope/vim-surround'

" ------------------------------------------------------------------------------
" text objects

" provide iv av for camel and snake case segments auto-determined
" provide ai and ii for indent blocks
" provide al and il for current line
" provide a_ and i_ for underscores
" provide a- and i-
Plug 'kana/vim-textobj-user'
      \| Plug 'Julian/vim-textobj-variable-segment'
      \| Plug 'kana/vim-textobj-indent'
      \| Plug 'kana/vim-textobj-line'
      \| Plug 'lucapette/vim-textobj-underscore'
      \| Plug 'mattn/vim-textobj-url'
      \| Plug 'RyanMcG/vim-textobj-dash'

" provide {, ", ', [, <, various other block objects
Plug 'paradigm/TextObjectify'

" ------------------------------------------------------------------------------
" syntax highlighting, spacing

" highlight matching html tag
Plug 'gregsexton/MatchTag',               { 'for': ['html', 'mustache', 'php', 'rb', 'xml'] }

Plug 'scrooloose/syntastic'

" ------------------------------------------------------------------------------
" Language specific
"
" Git --------------------------------------------------------------------------
" creates gitconfig, gitcommit, rebase
Plug 'tpope/vim-git'

Plug 'rhysd/committia.vim'

" HTML and generators ----------------------------------------------------------
Plug 'othree/html5.vim',                  { 'for': ['html', 'php'] }

Plug 'digitaltoad/vim-jade',              { 'for': ['jade'] }

" creates haml, sass, scss filetypes
Plug 'tpope/vim-haml'

" JavaScript / CoffeeScript ----------------------------------------------------
Plug 'heavenshell/vim-jsdoc', {
      \   'for':  ['html', 'javascript', 'php'],
      \   'on':   ['JsDoc'],
      \ }

" syntax highlighting for jQuery
"Plug 'itspriddle/vim-jquery',             { 'for': ['html', 'javascript', 'php'] }

" provides coffee ft
Plug 'kchmck/vim-coffee-script'

" react/JSX syn highlighting for .cjsx
Plug 'mtscout6/vim-cjsx'

" explicitly compatible with
"   othree/javascript-libraries-syntax.vim - jQuery,backbone,etc.
"   mxw/vim-jsx - react/JSX syn highlighting for .jsx
" replaces 'jelera/vim-javascript-syntax', {
" indenting/highlighting
"Plug 'pangloss/vim-javascript',           { 'for': ['html', 'javascript', 'php'] }
Plug 'othree/yajs.vim',
      \| Plug 'mxw/vim-jsx'
      \| Plug 'othree/javascript-libraries-syntax.vim'
      \| Plug 'othree/jspc.vim'

" JSON -------------------------------------------------------------------------
Plug 'elzr/vim-json',                     { 'for': ['json'] }

" Mustache.js and Handlebars ---------------------------------------------------
Plug 'mustache/vim-mustache-handlebars',  { 'for': ['html', 'mustache', 'hbs'] }

" Nginx ------------------------------------------------------------------------
Plug 'moskytw/nginx-contrib-vim'

" PHP --------------------------------------------------------------------------
"Plug 'dsawardekar/wordpress.vim'

" provides updated syntax
Plug 'StanAngeloff/php.vim',              { 'for': ['php', 'blade'] }
      \| Plug 'shawncplus/phpcomplete.vim',        { 'for': ['php', 'blade'] }

Plug 'tobyS/vmustache'
      \| Plug 'tobyS/pdv',              { 'for': ['php', 'blade'] }

" Ruby, rails, chef, puppet ----------------------------------------------------
" creates pp filetype
Plug 'rodjek/vim-puppet'

" highlighting for Gemfile
Plug 'tpope/vim-bundler'

Plug 'vadv/vim-chef',                     { 'for': ['ruby', 'eruby'] }

" creates ruby filetype
Plug 'vim-ruby/vim-ruby'

" Stylesheet languages ---------------------------------------------------------
Plug 'Rykka/colorv.vim'

" creates scss.css
Plug 'cakebaker/scss-syntax.vim'

" creates less filetype
Plug 'groenewege/vim-less'

Plug 'hail2u/vim-css3-syntax',            { 'for': ['css', 'scss'] }

" Better @media syntax highlighting
Plug 'JulesWang/css.vim',                 { 'for': ['css', 'scss'] }

" Twig -------------------------------------------------------------------------
" creates twig ft
Plug 'evidens/vim-twig'

" YAML -------------------------------------------------------------------------
Plug 'ingydotnet/yaml-vim'

call plug#end()

" Manually to preserve source order
source $VIM_DOTFILES/rc/Cmd2.vim
source $VIM_DOTFILES/rc/CoffeeTags.vim
source $VIM_DOTFILES/rc/airline.vim
source $VIM_DOTFILES/rc/colorv.vim
source $VIM_DOTFILES/rc/committia.vim
source $VIM_DOTFILES/rc/cosco.vim
source $VIM_DOTFILES/rc/gundo.vim
source $VIM_DOTFILES/rc/incsearch.vim
source $VIM_DOTFILES/rc/javascript-libraries-syntax.vim
source $VIM_DOTFILES/rc/neocomplete.vim
source $VIM_DOTFILES/rc/neosnippet.vim
source $VIM_DOTFILES/rc/pdv.vim
source $VIM_DOTFILES/rc/phpcomplete.vim
source $VIM_DOTFILES/rc/scss-syntax.vim
source $VIM_DOTFILES/rc/smartpairs.vim
source $VIM_DOTFILES/rc/solarized.vim
source $VIM_DOTFILES/rc/syntastic.vim
source $VIM_DOTFILES/rc/tabular.vim
source $VIM_DOTFILES/rc/tagbar.vim
source $VIM_DOTFILES/rc/tern_for_vim.vim
source $VIM_DOTFILES/rc/unite.vim
source $VIM_DOTFILES/rc/vim-anzu.vim
source $VIM_DOTFILES/rc/vim-coffee-script.vim
source $VIM_DOTFILES/rc/vim-css3-syntax.vim
source $VIM_DOTFILES/rc/vim-easyclip.vim
source $VIM_DOTFILES/rc/vim-indent-guides.vim
source $VIM_DOTFILES/rc/vim-instant-markdown.vim
source $VIM_DOTFILES/rc/vim-jsdoc.vim
source $VIM_DOTFILES/rc/vim-json.vim
source $VIM_DOTFILES/rc/vim-over.vim
source $VIM_DOTFILES/rc/vimfiler.vim

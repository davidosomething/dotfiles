" Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
  execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-helptab'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'

" creates dir if new file in new dir
Plug 'dockyard/vim-easydir'

" show registers in tem split if use \" or <C-R>
Plug 'junegunn/vim-peekaboo'

" auto tag generation via exuberant-ctags -- no tags file created
Plug 'majutsushi/tagbar',                 { 'on': [ 'TagbarToggle' ] }

Plug 'nathanaelkane/vim-indent-guides'

Plug 'now/vim-quit-if-only-quickfix-buffer-left'

" Most recently used files for unite.vim -- config is in unite.vim
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
      \| Plug 'Shougo/neomru.vim'
      \| Plug 'Shougo/unite.vim'
Plug 'Shougo/unite.vim'
      \| Plug 'Shougo/vimfiler.vim'

Plug 'sjl/gundo.vim',                     { 'on': [ 'GundoToggle' ] }

Plug 'suan/vim-instant-markdown',         { 'do': 'npm install -g instant-markdown-d' }

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
Plug 'Shougo/neocomplete.vim'

Plug 'Shougo/neosnippet'
      \| Plug 'honza/vim-snippets'
      \| Plug 'Shougo/neosnippet-snippets'

" ------------------------------------------------------------------------------
" editing keys
Plug 'godlygeek/tabular',                 { 'on': [ 'Tabularize' ] }

" viv, v, v to expand surround selection
Plug 'gorkunov/smartpairs.vim'

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
Plug 'kana/vim-textobj-user' | Plug 'Julian/vim-textobj-variable-segment'

" provide ai and ii for indent blocks
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-indent'

" provide al and il for current line
Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line'

" provide a_ and i_ for underscores
Plug 'kana/vim-textobj-user' | Plug 'lucapette/vim-textobj-underscore'

" provide al and il for current line
Plug 'kana/vim-textobj-user' | Plug 'mattn/vim-textobj-url'

" provide {, ", ', [, <, various other block objects
Plug 'paradigm/TextObjectify'

" provide a- and i-
Plug 'kana/vim-textobj-user' | Plug 'RyanMcG/vim-textobj-dash'

" ------------------------------------------------------------------------------
" syntax highlighting
Plug 'vim-scripts/PreserveNoEOL' | Plug 'editorconfig/editorconfig-vim'

" highlight matching html tag
Plug 'gregsexton/MatchTag',               { 'for': ['html', 'mustache', 'php', 'rb', 'xml'] }

Plug 'rhysd/conflict-marker.vim'

Plug 'scrooloose/syntastic'

Plug 'vim-scripts/PreserveNoEOL'

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

Plug 'tpope/vim-haml'              " creates haml, sass, scss filetypes

" JavaScript / CoffeeScript ----------------------------------------------------
Plug 'heavenshell/vim-jsdoc', {
      \   'for':  ['html', 'javascript', 'php'],
      \   'on':   ['JsDoc'],
      \ }

" syntax highlighting for jQuery
Plug 'itspriddle/vim-jquery',             { 'for': ['html', 'javascript', 'php'] }

" can't lazy this, provides coffee ft
Plug 'kchmck/vim-coffee-script'

" tagbar ctags for coffee
Plug 'majutsushi/tagbar' | Plug 'lukaszkorecki/CoffeeTags'

" react/JSX syn highlighting for .cjsx
Plug 'mtscout6/vim-cjsx'

" react/JSX syn highlighting for .jsx
Plug 'vim-javascript' | Plug 'mxw/vim-jsx'

Plug 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'coffee'] }

" Parameter completion
Plug 'othree/jspc.vim',                   { 'for': ['javascript', 'coffee'] }

" explicitly compatible with
"   vim-javascript-syntax
"   vim-javascript-libraries-syntax
"   vim-jsx
" replaces 'jelera/vim-javascript-syntax', {
Plug 'othree/yajs.vim',                   { 'for': ['html', 'javascript', 'php'] }

Plug 'pangloss/vim-javascript',           { 'for': ['html', 'javascript', 'php'] }

" JSON -------------------------------------------------------------------------
Plug 'elzr/vim-json',                     { 'for': ['json'] }

" Mustache.js and Handlebars ---------------------------------------------------
Plug 'mustache/vim-mustache-handlebars',  { 'for': ['html', 'mustache', 'hbs'] }

Plug 'moskytw/nginx-contrib-vim'

" PHP --------------------------------------------------------------------------
"Plug 'dsawardekar/wordpress.vim'

Plug 'shawncplus/phpcomplete.vim',        { 'for': ['php', 'blade'] }

" provides updated syntax
Plug 'StanAngeloff/php.vim',              { 'for': ['php', 'blade'] }

Plug 'tobyS/vmustache' | Plug 'tobyS/pdv', { 'for': ['php', 'blade'] }

Plug 'majutsushi/tagbar' | Plug 'vim-php/tagbar-phpctags.vim', {
      \   'for': ['php', 'blade'],
      \   'do': 'make',
      \ }

" Ruby, rails, chef, puppet ----------------------------------------------------
" creates pp filetype
Plug 'rodjek/vim-puppet'

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

source $VIM_DOTFILES/rc/Cmd2.vim
source $VIM_DOTFILES/rc/CoffeeTags.vim
source $VIM_DOTFILES/rc/airline.vim
source $VIM_DOTFILES/rc/colorv.vim
source $VIM_DOTFILES/rc/committia.vim
source $VIM_DOTFILES/rc/cosco.vim
source $VIM_DOTFILES/rc/gundo.vim
source $VIM_DOTFILES/rc/incsearch.vim
source $VIM_DOTFILES/rc/neocomplete.vim
source $VIM_DOTFILES/rc/pdv.vim
source $VIM_DOTFILES/rc/phpcomplete.vim
source $VIM_DOTFILES/rc/scss-syntax.vim
source $VIM_DOTFILES/rc/smartpairs.vim
source $VIM_DOTFILES/rc/solarized.vim
source $VIM_DOTFILES/rc/syntastic.vim
source $VIM_DOTFILES/rc/tabular.vim
source $VIM_DOTFILES/rc/tagbar.vim
source $VIM_DOTFILES/rc/unite.vim
source $VIM_DOTFILES/rc/vim-anzu.vim
source $VIM_DOTFILES/rc/vim-coffee-script.vim
source $VIM_DOTFILES/rc/vim-css3-syntax.vim
source $VIM_DOTFILES/rc/vim-easyclip.vim
source $VIM_DOTFILES/rc/vim-indent-guides.vim
source $VIM_DOTFILES/rc/vim-instant-markdown.vim
source $VIM_DOTFILES/rc/vim-javascript.vim
source $VIM_DOTFILES/rc/vim-jsdoc.vim
source $VIM_DOTFILES/rc/vim-json.vim
source $VIM_DOTFILES/rc/vim-over.vim
source $VIM_DOTFILES/rc/vimfiler.vim

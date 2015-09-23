" Load vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

" ----------------------------------------------------------------------------
" Appearance/tab/split mgmt --------------------------------------------------
" ----------------------------------------------------------------------------

Plug 'chriskempson/base16-vim'

Plug 'bling/vim-airline'

" Open help in new tab
Plug 'airblade/vim-helptab'

Plug 'now/vim-quit-if-only-quickfix-buffer-left'

" ----------------------------------------------------------------------------
" UI -------------------------------------------------------------------------
" ----------------------------------------------------------------------------

" highlight partial matches as you type in search mode
Plug 'haya14busa/incsearch.vim'

" show registers in split if use \" or <C-R>
Plug 'junegunn/vim-peekaboo'

" Show (#/total results) when searching for a term
Plug 'osyo-manga/vim-anzu'

" ----------------------------------------------------------------------------
" File system ----------------------------------------------------------------
" ----------------------------------------------------------------------------

" creates dir if new file in new dir
Plug 'dockyard/vim-easydir'

" ----------------------------------------------------------------------------
" Commands -------------------------------------------------------------------
" ----------------------------------------------------------------------------

Plug 'suan/vim-instant-markdown',         { 'on': ['InstantMarkdownPreview'], 'for': ['markdown'], 'do': 'npm install -g instant-markdown-d' }

" Mostly for :Gblame
Plug 'tpope/vim-fugitive'

" <F1> fuzzy find
" <F2> recently used
" <F3> grep
" <F9> file browser
" Most recently used files for unite.vim -- config is in unite.vim
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
      \| Plug 'Shougo/neomru.vim'
      \| Plug 'Shougo/unite.vim'
      \| Plug 'Shougo/vimfiler.vim'

" <F5> toggle color
Plug 'altercation/vim-colors-solarized'

" <F6>
Plug 'nathanaelkane/vim-indent-guides',   { 'on': ['<Plug>IndentGuidesToggle'] }

" <F7> - command mode with instant results when doing subst %s
Plug 'osyo-manga/vim-over',               { 'on': ['OverCommandLine'] }

" <F8> - command mode with tab-completion and suggestions for commands
Plug 'gelguy/Cmd2.vim'

" <F10> tagbar
" auto tag generation via exuberant-ctags -- no tags file created
Plug 'majutsushi/tagbar',                 { 'on': ['TagbarToggle'] }
      \| Plug 'lukaszkorecki/CoffeeTags', { 'for': ['coffee'] }
      \| Plug 'vim-php/tagbar-phpctags.vim', { 'for': ['php', 'blade'], 'do': 'make' }

" <F11>
Plug 'sjl/gundo.vim',                     { 'on': ['GundoToggle'] }

" Add file manip commands like Remove, Move, Rename, SudoWrite
Plug 'tpope/vim-eunuch'

" ----------------------------------------------------------------------------
" Completion -----------------------------------------------------------------
" ----------------------------------------------------------------------------

if has('lua')
  Plug 'Shougo/neocomplete.vim'
  Plug 'Shougo/neco-syntax'
endif

let g:dko_use_tern_completion = 0
if g:dko_use_tern_completion
  Plug 'marijnh/tern_for_vim',            { 'for': ['javascript', 'typescript'], 'do': 'npm install' }
endif

Plug 'Shougo/neosnippet'
      \| Plug 'honza/vim-snippets'
      \| Plug 'Shougo/neosnippet-snippets'

" ----------------------------------------------------------------------------
" Editing keys ---------------------------------------------------------------
" ----------------------------------------------------------------------------

Plug 'godlygeek/tabular',                 { 'on': ['Tabularize'] }

" viv, v, v to expand surround selection
Plug 'gorkunov/smartpairs.vim'

Plug 'rhysd/conflict-marker.vim'

" ;; or ,, to auto-insert comma or semicolon at end of current line as needed
Plug 'lfilho/cosco.vim'

Plug 'svermeulen/vim-easyclip'

" custom C-x C-a mappings
Plug 'nishigori/increment-activator'

Plug 'tomtom/tcomment_vim'

Plug 'tpope/vim-repeat'

" fast increment datetimes
Plug 'tpope/vim-speeddating'

Plug 'tpope/vim-surround'

" used for line bubbling commands on osx
Plug 'tpope/vim-unimpaired'

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

" ----------------------------------------------------------------------------
" Syntax highlighting, spacing -----------------------------------------------
" ----------------------------------------------------------------------------

Plug 'vim-scripts/PreserveNoEOL'
      \| Plug 'editorconfig/editorconfig-vim'

" highlight matching html tag
Plug 'gregsexton/MatchTag',               { 'for': ['html', 'mustache', 'php', 'rb', 'xml'] }

Plug 'scrooloose/syntastic'

" ----------------------------------------------------------------------------
" Language -------------------------------------------------------------------
" ----------------------------------------------------------------------------

" special end syntax for various langs
Plug 'tpope/vim-endwise'

" Git ------------------------------------------------------------------------

" creates gitconfig, gitcommit, rebase
Plug 'tpope/vim-git'

" show multipanes when editing a COMMIT_EDITMSG
Plug 'rhysd/committia.vim'

" HTML and generators --------------------------------------------------------

Plug 'othree/html5.vim',                  { 'for': ['html', 'php'] }

Plug 'digitaltoad/vim-jade'

Plug 'tpope/vim-haml'

" JavaScript / CoffeeScript --------------------------------------------------

Plug 'heavenshell/vim-jsdoc',             { 'for':  ['html', 'javascript', 'php'], 'on': ['JsDoc'], }

" syntax highlighting for jQuery
"Plug 'itspriddle/vim-jquery',             { 'for': ['html', 'javascript', 'php'] }

" provides coffee ft
Plug 'kchmck/vim-coffee-script'

" react/JSX syn highlighting for .cjsx
Plug 'mtscout6/vim-cjsx'

" indenting/highlighting, replaces 'jelera/vim-javascript-syntax', {
"Plug 'pangloss/vim-javascript', { 'for': ['html', 'javascript', 'php'] }
Plug 'othree/yajs.vim', { 'for': ['html', 'javascript', 'php'] }

"Plug 'othree/jspc.vim', { 'for': ['html', 'javascript', 'php'] }

" extends syntax for with jQuery,backbone,etc.
"Plug 'othree/javascript-libraries-syntax.vim', { 'for': ['html', 'javascript', 'php'] }

" mxw/vim-jsx - react/JSX syn highlighting for .jsx
" requires a javascript syntax plugin first (e.g. yajs or vim-javascript)
Plug 'mxw/vim-jsx'

" JSON -----------------------------------------------------------------------

Plug 'elzr/vim-json',                     { 'for': ['json'] }

" Mustache.js and Handlebars -------------------------------------------------

" Creates html.handlebars and other fts and sets syn
Plug 'mustache/vim-mustache-handlebars'

" Nginx ----------------------------------------------------------------------

Plug 'moskytw/nginx-contrib-vim'

" PHP ------------------------------------------------------------------------

" creates twig ft
Plug 'evidens/vim-twig'

" provides updated syntax
Plug 'StanAngeloff/php.vim',              { 'for': ['php', 'blade'] }
      \| Plug 'shawncplus/phpcomplete.vim', { 'for': ['php'] }
      "\| Plug 'dsawardekar/wordpress.vim', { 'for': ['php'] }

Plug 'tobyS/vmustache',                   { 'for': ['php', 'blade'] }
      \| Plug 'tobyS/pdv',                { 'for': ['php', 'blade'] }

" Ruby, rails, chef, puppet --------------------------------------------------

" creates pp filetype
Plug 'rodjek/vim-puppet'

" highlighting for Gemfile
Plug 'tpope/vim-bundler'

Plug 'vadv/vim-chef',                     { 'for': ['ruby', 'eruby'] }

" creates ruby filetype
Plug 'vim-ruby/vim-ruby'

" Stylesheet languages -------------------------------------------------------
Plug 'Rykka/colorv.vim'

" creates less filetype
Plug 'groenewege/vim-less'

" extends vim's css highlighting
Plug 'hail2u/vim-css3-syntax',            { 'for': ['css', 'scss'] }

" css.vim provides @media syntax highlighting where hail2u doesn't
Plug 'JulesWang/css.vim',                 { 'for': ['css', 'scss'] }
      \| Plug 'cakebaker/scss-syntax.vim'

" YAML -----------------------------------------------------------------------

Plug 'ingydotnet/yaml-vim'

" ----------------------------------------------------------------------------
" End of plugins -------------------------------------------------------------
" ----------------------------------------------------------------------------
call plug#end()

" ----------------------------------------------------------------------------
" Plugin configs -------------------------------------------------------------
" ----------------------------------------------------------------------------

" Source manually to preserve source order
source $VIM_DOTFILES/rc/Cmd2.vim
source $VIM_DOTFILES/rc/CoffeeTags.vim
source $VIM_DOTFILES/rc/airline.vim
source $VIM_DOTFILES/rc/base16-vim.vim
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
if g:dko_use_tern_completion
  source $VIM_DOTFILES/rc/tern_for_vim.vim
endif
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

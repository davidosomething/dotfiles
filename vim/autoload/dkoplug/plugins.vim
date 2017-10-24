function! dkoplug#plugins#LoadAll() abort
  " Notes on adding plugins:
  " - Absolutely do not use 'for' if the plugin provides an `ftdetect/`

  " ==========================================================================
  " Vim debugging
  " ==========================================================================

  " Show slow plugins
  Plug 'tweekmonster/startuptime.vim', { 'on': [ 'StartupTime' ] }

  " `:Bufferize messages` to get messages (or any :command) in a new buffer
  Plug 'AndrewRadev/bufferize.vim', { 'on': [ 'Bufferize' ] }

  Plug 'cocopon/colorswatch.vim', { 'on': [ 'ColorSwatchGenerate' ] }

  " :DocOpen to open the current help.txt file in browser
  Plug 'nelstrom/vim-docopen', { 'on': [ 'DocOpen' ] }

  " Mostly for zS to debug hilight group (:Bufferize scriptnames is nicer
  " than :Scriptnames)
  Plug 'tpope/vim-scriptease', { 'on': [
        \   'PP', 'Scriptnames', 'Messages', '<Plug>Scriptease'
        \ ] }

  " ==========================================================================
  " Colorscheme
  " ==========================================================================

  "Plug '~/projects/davidosomething/vim-base2tone-lakedark'
  Plug 'davidosomething/vim-base2tone-lakedark'
  "Plug 'AlessandroYorba/Sidonia'
  Plug 'rakr/vim-two-firewatch'
  "Plug 'arcticicestudio/nord-vim'

  " ==========================================================================
  " Embedded filetype support
  " ==========================================================================

  " tyru/caw.vim, deoplete, some others use this to determine inline embedded
  " filetypes
  Plug 'Shougo/context_filetype.vim'

  " ==========================================================================
  " File system, ctags
  " ==========================================================================

  Plug 'ludovicchabant/vim-gutentags', PlugIf(executable('ctags'))

  "Plug 'majutsushi/tagbar', PlugIf(executable('ctags'))

  " ctags on-the-fly processing
  " This is a nice function context plugin but too many false positives
  "Plug 'jeetsukumaran/vim-gazetteer', PlugIf(executable('ctags'))

  " ==========================================================================
  " Commands
  " ==========================================================================

  let l:fzfable = !empty(g:fzf_dir)
        \ && v:version >= 704
        \ && (has('nvim') || $TERM_PROGRAM ==# 'iTerm.app')
  if !empty(g:fzf_dir)
    Plug g:fzf_dir, PlugIf(l:fzfable)
    Plug 'junegunn/fzf.vim', PlugIf(l:fzfable)
    Plug g:dko#vim_dir . '/mine/vim-dko-fzf', PlugIf(l:fzfable, { 'on': [
          \   'FZFGrepper',
          \   'FZFMRU',
          \   'FZFProject',
          \   'FZFRelevant',
          \   'FZFSpecs',
          \   'FZFVim',
          \ ]})
  endif

  " gK to lookup
  Plug 'keith/investigate.vim'

  " :Bdelete to preserve windows
  Plug 'moll/vim-bbye'

  Plug 'nathanaelkane/vim-indent-guides'

  Plug 'osyo-manga/vim-over', { 'on': [ 'OverCommandLine' ] }

  Plug 'sbdchd/neoformat'

  " Add file manip commands like Remove, Move, Rename, SudoWrite
  " Do not lazy load, tracks buffers
  Plug 'tpope/vim-eunuch'

  " <C-w>o to zoom in/out of a window
  "Plug 'dhruvasagar/vim-zoom'
  " Better zoom plugin, accounts for command window and doesn't use sessions
  Plug 'troydm/zoomwintab.vim'

  " in command mode, alt-f/b to go forward/back words
  Plug 'vim-utils/vim-husk'

  " ==========================================================================
  " Input, syntax, spacing
  " ==========================================================================

  Plug 'sgur/vim-editorconfig'

  " highlight matching html tag
  Plug 'gregsexton/MatchTag'

  " highlight lines corresponding to quickfix entries
  Plug 'jceb/vim-hier', { 'on': [ 'HierStart' ] }

  " add gS on char to smart split lines at char, like comma lists and html tags
  Plug 'AndrewRadev/splitjoin.vim'

  " Compatible with Neovim or Vim with this patch level
  Plug 'neomake/neomake', PlugIf(has('patch-7.4.503'))
  "Plug '~/projects/neomake'

  Plug 'tyru/current-func-info.vim'
  "Plug '~/projects/current-func-info.vim'

  " ==========================================================================
  " Editing keys
  " ==========================================================================

  Plug 'godlygeek/tabular', { 'on': [ 'Tabularize' ] }

  Plug 'bootleq/vim-cycle', { 'on': [ '<Plug>Cycle' ]}

  Plug 'tpope/vim-repeat'

  " easyclip requires repeat, REMAPS all register keys (y,d,s,c,etc.)
  " and use 'm' instead
  " Only on Neovim, because someone else is probably using my computer if
  " they're using regular vim
  Plug 'svermeulen/vim-easyclip', PlugIf(has('nvim'))

  " []-bindings -- buffer switch, lnext/prev, etc.
  " My fork has a lot of removals like line movement and entities
  Plug 'davidosomething/vim-unimpaired'

  " used for line bubbling commands (instead of unimpared!)
  " Consider also t9md/vim-textmanip
  Plug 'matze/vim-move'

  Plug 'kana/vim-operator-user'
  " gcc to toggle comment
  Plug 'tyru/caw.vim', { 'on': [ '<Plug>(caw' ]}
  " <Leader>s(a/r/d) to modify surrounding the pending operator
  Plug 'rhysd/vim-operator-surround'
  " <Leader>c to toggle CamelCase/snak_e the pending operator
  Plug 'tyru/operator-camelize.vim'

  " Some textobjs are lazy loaded since they are ~4ms slow to load.
  " See plugin/textobj.vim to see how they're mapped.
  " -       Base textobj plugin
  Plug 'kana/vim-textobj-user'
  " - d/D   for underscore section (e.g. `did` on foo_b|ar_baz -> foo__baz)
  Plug 'machakann/vim-textobj-delimited'
  " - i     for indent level
  Plug 'kana/vim-textobj-indent', { 'on': [ '<Plug>(textobj-indent' ]}
  " - l     for current line
  Plug 'kana/vim-textobj-line', { 'on': [ '<Plug>(textobj-line' ]}
  " - u     for url
  Plug 'mattn/vim-textobj-url', { 'on': [ '<Plug>(textobj-url' ]}
  " - b     for any block type (parens, braces, quotes, ltgt)
  Plug 'rhysd/vim-textobj-anyblock'
  " - x     for xml attr like `data-content="everything"`
  Plug 'whatyouhide/vim-textobj-xmlattr', { 'on': [
        \   '<Plug>(textobj-xmlattr',
        \ ]}

  " HR with <Leader>f[CHAR]
  Plug g:dko#vim_dir . '/mine/vim-hr'

  " <Leader>C <Plug>(dkosmallcaps)
  Plug g:dko#vim_dir . '/mine/vim-smallcaps', { 'on': '<Plug>(dkosmallcaps)' }

  " Toggle movement mode line-wise/display-wise
  Plug g:dko#vim_dir . '/mine/vim-movemode'

  " ==========================================================================
  " Completion
  " ==========================================================================

  " Auto-insert matching braces with detection for jumping out on close.
  Plug 'cohama/lexima.vim'
  "Plug 'Raimondi/delimitMate' SLOWER LOAD
  "Plug 'kana/vim-smartinput' SLOW

  " Main completion engine, bound to <C-o>
  " Does not start until InsertEnter, so we can set up sources, then load
  " them, then load NCM
  Plug 'roxma/nvim-completion-manager', PlugIf(g:dko_use_completion, {
        \   'on': []
        \ })

  " Always provide deoplete, may or may not be bound to <C-o> depending on if
  " use_ncm, in which case deoplete Forwards to nvim-completion-manager for
  " some sources (e.g. deoplete-padawan for php since langserver above didn't
  " work for me.)
  "
  " context_filetype.vim provides mixed-filetype completion for deoplete,
  " e.g. highlight JS within Markdown fenced code blocks.
  " nvim-completion-manager already has this functionality built in.
  "
  " Currently forwarding to NCM:
  " - deoplete-padawan (deoplete)
  " - jspc.vim (omni only)
  Plug 'Shougo/deoplete.nvim', PlugIf(g:dko_use_deoplete, {
        \   'do': ':UpdateRemotePlugins'
        \ })

  " The language client completion is a bit slow to kick in, but it works
  let l:use_langserver = !g:dko_use_deoplete
  Plug 'autozimu/LanguageClient-neovim', PlugIf(l:use_langserver, {
        \   'do': ':UpdateRemotePlugins'
        \ })

  " --------------------------------------------------------------------------
  " NCM/Deoplete functionality: Includes
  " --------------------------------------------------------------------------

  " Include completion, include tags
  " For what langs are supported, see:
  " https://github.com/Shougo/neoinclude.vim/blob/master/autoload/neoinclude.vim
  "
  " NCM Errors when can't find b:node_root
  "Plug 'Shougo/neoinclude.vim', PlugIf(g:dko_use_completion)

  " --------------------------------------------------------------------------
  " Completion: CSS
  " --------------------------------------------------------------------------

  " Omnicompletion, this is beta repo, where stables are already in VIMRUNTIME
  "Plug 'othree/csscomplete.vim'

  Plug 'calebeby/ncm-css', PlugIf(g:dko_use_completion)

  " --------------------------------------------------------------------------
  " Completion: Java
  " --------------------------------------------------------------------------

  Plug 'sassanh/nvim-cm-eclim', PlugIf(g:dko_use_completion)

  " Plug 'artur-shaik/vim-javacomplete2', PlugIf(executable('mvn'), {
  "       \   'do': 'cd -- libs/javavi/ && mvn compile',
  "       \   'for': 'java',
  "       \ })

  " --------------------------------------------------------------------------
  " Completion: JavaScript
  " --------------------------------------------------------------------------

  " Code analysis completion
  " Langserver disabled
  let g:dko_use_js_langserver = 0 && g:dko_use_completion
        \ && l:use_langserver
        \ && !empty(dkonode#Langserver())
  let l:use_tern = g:dko_use_completion
        \ && !g:dko_use_js_langserver
        \ && executable('npm')

  " faster than deoplete implementation
  Plug 'roxma/nvim-cm-tern', PlugIf(l:use_tern, { 'do': 'npm install' })

  " slower than nvim-cm-tern
  " Plug 'carlitux/deoplete-ternjs', PlugIf(l:use_tern, {
  "   \   'do': 'npm install --global tern'
  "   \ })

  " Complete imports (slow, consider set up in .tern-project instead)
  " Plug 'neovim/node-host', { 'do': 'npm install' }
  "       \ | Plug 'billyvg/jsimport.nvim'

  " Nice generic omnifunc when no completion engine
  Plug '1995eaton/vim-better-javascript-completion',
        \ PlugIf(!l:use_tern && !g:dko_use_js_langserver)

  " Parameter completion (in or after ' or ")
  " Extends omnicomplete to fill in addEventListener('click'
  " Forwarded by deoplete to nvim-completion-manager
  " Does not work in deoplete -- use as omnicomplete only!
  " E.g. specific g:deoplete#omni_patterns so omnifunction is called directly
  Plug 'othree/jspc.vim'

  " ----------------------------------
  " Flow
  " ----------------------------------

  " Native omnicomplete and some refactoring support, official plugin
  "Plug 'flowtype/vim-flow'

  " NCM completion, same deps as vim-flow
  " not using until this is fixed: https://github.com/roxma/ncm-flow/issues/3
  "Plug 'roxma/ncm-flow', PlugIf(g:dko_use_completion)

  " Deoplete completion (forwarded to NCM)
  Plug 'wokalski/autocomplete-flow', PlugIf(g:dko_use_deoplete)

  " --------------------------------------------------------------------------
  " Completion: PHP
  " --------------------------------------------------------------------------
  "
  let l:use_composer = g:dko_use_completion
        \ && has('nvim')
        \ && executable('composer')
  if l:use_composer
    Plug 'padawan-php/deoplete-padawan', PlugIf(g:dko_use_deoplete, {
          \   'do': 'composer install'
          \ })

    Plug 'roxma/LanguageServer-php-neovim', PlugIf(l:use_langserver, {
          \   'do': 'composer install && composer run-script parse-stubs'
          \ })
  endif

  " Possible vanilla plugins - may work with deoplete
  " 'phpvim/phpcd.vim'              - server based completion
  " 'mkusher/padawan.vim'           - server based completion for VIM
  " 'm2mdas/phpcomplete-extended'   - fast via vimproc, but dead
  " 'shawncplus/phpcomplete.vim'    - slow as fuck, included in VIMRUNTIME.
  "                                   this is upstream. tags based

  " Alternative PHP completion daemon, never got it working...
  "   Plug 'phpvim/phpcd.vim', {
  "         \   'do': 'composer update',
  "         \   'for': 'php'
  "         \ }

  Plug 'shawncplus/phpcomplete.vim', PlugIf(!l:use_composer, { 'for': 'php' })

  " --------------------------------------------------------------------------
  " Completion: Python
  " --------------------------------------------------------------------------

  " nvim-completion-manager has a jedi source in python already, so as long as
  " jedi is pip installed it is good to go.

  " Forwarded to nvim-completion-manager if present
  " Plug 'zchee/deoplete-jedi'

  " --------------------------------------------------------------------------
  " Completion: Syntax
  " --------------------------------------------------------------------------

  " Full syntax completion. Keyed as [S]
  " Only use with NCM - normally super slow, like syntaxcomplete
  " DISABLED - Makes pandoc/markdown really slow.
  "Plug 'Shougo/neco-syntax', PlugIf(g:dko_use_completion)

  " --------------------------------------------------------------------------
  " Completion: Snippet engine
  " --------------------------------------------------------------------------

  " nvim-completion-manager and deoplete
  Plug 'Shougo/neosnippet', PlugIf(g:dko_use_completion)
  Plug 'Shougo/neosnippet-snippets', PlugIf(g:dko_use_completion)
  Plug 'honza/vim-snippets', PlugIf(g:dko_use_completion)

  " --------------------------------------------------------------------------
  " Completion: VimL
  " --------------------------------------------------------------------------

  " nvim-completion-manager and deoplete (disabled deoplete integration)
  Plug 'Shougo/neco-vim', PlugIf(g:dko_use_completion)

  " ==========================================================================
  " Multiple languages
  " ==========================================================================

  Plug 'itchyny/vim-parenmatch'

  " special end syntax for various langs
  Plug 'tpope/vim-endwise'

  " ==========================================================================
  " Language: bash/shell/zsh
  " ==========================================================================

  " Upstreams
  Plug 'chrisbra/vim-sh-indent'
  Plug 'chrisbra/vim-zsh'

  " ==========================================================================
  " Language: D
  " ==========================================================================

  Plug 'idanarye/vim-dutyl', { 'for': 'd' }

  " ==========================================================================
  " Language: Git
  " ==========================================================================

  " creates gitconfig, gitcommit, rebase
  " provides :DiffGitCached in gitcommit file type
  " vim 7.4-77 ships with 2013 version, this is newer
  Plug 'tpope/vim-git'

  " show diff when editing a COMMIT_EDITMSG
  Plug 'rhysd/committia.vim'

  " ==========================================================================
  " Language: HTML, XML, and generators: mustache, handlebars
  " ==========================================================================

  " Syntax enhancements and htmlcomplete#CompleteTags function override
  " The completion function doesn't work with deoplete
  " @see https://github.com/Shougo/deoplete.nvim/issues/65
  " @see https://github.com/Shougo/deoplete.nvim/issues/70
  "Plug 'othree/html5.vim'

  "Plug 'tpope/vim-haml'

  " Creates html.handlebars and other fts and sets syn
  Plug 'mustache/vim-mustache-handlebars'

  " ==========================================================================
  " Language: Java
  " ==========================================================================

  Plug 'dansomething/vim-eclim'

  " ==========================================================================
  " Language: JavaScript and derivatives, JSON
  " ==========================================================================

  Plug g:dko#vim_dir . '/mine/vim-pj'

  Plug 'elzr/vim-json'

  " provides coffee ft
  "Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
  " The upstream has after/* garbage that messes with <script> html blocks in
  " php files
  Plug 'davidosomething/vim-coffee-script', {
        \   'for':    'coffee',
        \   'branch': 'noft'
        \ }

  " TypeScript
  Plug 'leafgarland/typescript-vim'
  " Alternatively
  "Plug 'HerringtonDarkholme/yats.vim'

  " ----------------------------------------
  " Syntax
  " Configured in plugin/plug-vim-javascript.vim
  " ----------------------------------------

  " COMBINED AND MODIFIED pangloss + vim-jsx-pretty
  " Not well maintained
  "Plug 'neoclide/vim-jsx-improve'

  " PANGLOSS MODE - this is vim upstream now!
  " 1.  Preferring pangloss for now since I like the included indentexpr
  "     it also has a node ftdetect, but that is the same as in
  "     moll/vim-node
  " 2.  After syntax, ftplugin, indent for JSX
  Plug 'pangloss/vim-javascript'

  " YAJS MODE
  " 1.  yajs.vim highlighting is a little more robust than the pangloss one.
  " 2.  The libraries syntax adds unique highlighting for
  "     jQuery,backbone,etc. and I've confirmed it is only compatible with
  "     yajs.vim as of 2016-11-03.
  " 3.  es.next support has possible jsx indent conflicts
  "     @see https://github.com/othree/es.next.syntax.vim/issues/5
  " Plug 'othree/yajs.vim'
  " Plug 'othree/javascript-libraries-syntax.vim'
  " Plug 'othree/es.next.syntax.vim'

  " ----------------------------------
  " Template strings
  " ----------------------------------

  " `:JsPreTmpl html` to highlight `<div></div>` template strings
  Plug 'Quramy/vim-js-pretty-template'

  " ----------------------------------
  " JSX
  " ----------------------------------

  " Works with both pangloss/othree
  " Offers inline code highlighting in JSX blocks, as well as vim-jsx's hi
  Plug 'maxmellon/vim-jsx-pretty'

  " ALTERNATE, original
  "Plug 'mxw/vim-jsx'

  " ----------------------------------
  " GraphQL
  " ----------------------------------

  Plug 'paulrosania/vim-graphql', { 'branch': 'tagged-template-literals' }
  " graphql upstream is https://github.com/jparise/vim-graphql

  " ----------------------------------------
  " Features
  " ----------------------------------------

  " detect extensionless node scripts (executables) via shebang
  " and add gf for going to node_modules files
  Plug 'moll/vim-node'

  " For refactoring only, not completion
  Plug 'ternjs/tern_for_vim', PlugIf(executable('npm'), {
        \   'do': 'npm install --global tern'
        \ })

  " ==========================================================================
  " Language: Markdown, Pandoc
  " ==========================================================================

  " Override vim included markdown ft* and syntax
  " The git repo has a newer syntax file than the one that ships with vim
  "Plug 'tpope/vim-markdown'

  " Enable pandoc filetype options and vim operators/fns
  Plug 'vim-pandoc/vim-pandoc', PlugIf(v:version >= 704)

  " Use pandoc for markdown syntax
  Plug 'vim-pandoc/vim-pandoc-syntax'

  " ==========================================================================
  " Language: Nginx
  " Disabled, rarely used.
  " ==========================================================================

  "Plug 'chr4/nginx.vim'

  " Same as in official upstream, @mhinz tends to update more often
  " @see http://hg.nginx.org/nginx/file/tip/contrib/vim
  " Plug 'mhinz/vim-nginx'
  "Plug 'moskytw/nginx-contrib-vim'

  " ==========================================================================
  " Language: PHP, twig
  " ==========================================================================

  " ----------------------------------------
  " Syntax
  " ----------------------------------------

  " creates twig ft
  "Plug 'evidens/vim-twig'

  " Syntax

  " Neovim comes with
  "   https://jasonwoof.com/gitweb/?p=vim-syntax.git;a=blob;f=php.vim;hb=HEAD
  " 2072 has a fork of an older version but has support for php 5.6 and other
  " changes. It does not support embedded HTML with Neovim
  "Plug '2072/vim-syntax-for-PHP'

  " Updated for php 7.1, Jan 2017 (newer than neovim 2.0 runtime)
  Plug 'StanAngeloff/php.vim', { 'for': 'php' }

  " Indent
  " 2072 is included with vim, this is upstream
  Plug '2072/PHP-Indenting-for-VIm'

  " Fix indent of HTML in all PHP files -- basically adds indent/html.vim when
  " outside of PHP block.
  " This actually never loads since 2072 sets b:did_indent
  " Also not needed since 2072 uses <script.*> style indenting for HTML
  "Plug 'captbaritone/better-indent-support-for-php-with-html'

  " ==========================================================================
  " Language: Python
  " ==========================================================================

  " Vim's python ftplugin upstream
  " Not a valid plugin runtime structure, file needs to be in ftplugin/
  "Plug 'sullyj3/vim-ftplugin-python'

  Plug 'lambdalisue/vim-pyenv', { 'for': 'python' }
  Plug 'Vimjas/vim-python-pep8-indent'
  Plug 'raimon49/requirements.txt.vim', { 'for': 'requirements' }

  " ==========================================================================
  " Language: Ruby, rails, puppet
  " ==========================================================================

  " creates pp filetype
  "Plug 'rodjek/vim-puppet'

  " highlighting for Gemfile
  "Plug 'tpope/vim-bundler'

  " creates ruby filetype
  "Plug 'vim-ruby/vim-ruby'

  " ==========================================================================
  " Language: Stylesheets
  " ==========================================================================

  " ----------------------------------------
  " Syntax
  " ----------------------------------------

  " creates less filetype
  " Conflicts with vim-css-color
  " Upstream Neovim uses https://github.com/genoma/vim-less
  "   - older
  "   - more groups
  "   - no conflict with vim-css-color
  "Plug 'groenewege/vim-less'

  " 1)  runtime css.vim provides @media syntax highlighting where hail2u
  "     doesn't JulesWang/css.vim was upstream for $VIMRUNTIME up until Vim 8
  "     - Only needed for old vim!!
  " 2)  hail2u extends vim's css highlighting
  "     - Super up-to-date with spec, after syntax that extends runtime
  " 3)  scss-syntax needs the 'for' since it has an ftdetect that doesn't check
  "     if the ft was already set. The result is that without 'for', the
  "     filetype will be set twice successively (and any autocommands will run
  "     twice), particularly in neovim which comes with tpope's (older) scss
  "     rumtimes.
  "     - Extra indent support
  "     - NeoVim comes with tpope's 2010 syntax that pulls in sass.vim and
  "       adds comment matching. sass.vim is okay, but doesn't have as many hi
  "       groups.
  Plug 'JulesWang/css.vim', PlugIf(v:version <= 704)
  Plug 'hail2u/vim-css3-syntax'
  Plug 'cakebaker/scss-syntax.vim', { 'for': [ 'scss' ] }

  " Hex (et al) color highlighting
  "Plug 'Rykka/colorv.vim'    --  requires python
  "Plug 'chrisbra/Colorizer'  --  slower and not as complete but more features
  "                               like X11 colors and color translation for
  "                               degraded terminals
  Plug 'ap/vim-css-color'

  " ==========================================================================
  " Language: .tmux.conf
  " ==========================================================================

  Plug 'tmux-plugins/vim-tmux'

  " ==========================================================================
  " Language: VimL
  " ==========================================================================

  Plug 'machakann/vim-vimhelplint'

  " gf to go to where autoloaded function is defined
  Plug 'kana/vim-gf-user', { 'for': [ 'vim' ] }
  Plug 'sgur/vim-gf-autoload', { 'for': [ 'vim' ] }

  " Auto-prefix continuation lines with \
  Plug 'lambdalisue/vim-backslash'

  "Plug 'syngan/vim-vimlint', PlugIf(executable('vimlparser'))

  " ==========================================================================
  " Search
  " See after/plugin/search.vim for complex configutation
  " ==========================================================================

  " <Plug> to not move on * search function
  Plug 'haya14busa/vim-asterisk'

  " @see https://github.com/haya14busa/incsearch.vim/issues/79
  " @see https://github.com/neovim/neovim/issues/3688
  " highlight partial matches as you type in search mode
  Plug 'haya14busa/incsearch.vim', PlugIf(v:version >= 704)

  " Show (#/total results) when searching for a term
  " known echo issue if remapping [[ and ]], but I removed that map
  " @see https://github.com/osyo-manga/vim-anzu/issues/19
  Plug 'osyo-manga/vim-anzu'

  " ==========================================================================
  " UI -- load last!
  " ==========================================================================

  " Using quickfixsigns_vim instead of these
  " :EC and :DC to enable/disable changes plugin
  " if v:version >= 800
  "   Plug 'chrisbra/changesPlugin', { 'on': [ 'EC' ] }
  " else
    " :GitGutterToggle (bound to C-g)
  "   Plug 'airblade/vim-gitgutter', { 'on': [ 'GitGutterToggle' ] }
  " endif

  Plug 'wellle/visual-split.vim', { 'on': [
        \   'VSResize', 'VSSplit',
        \   'VSSplitAbove', 'VSSplitBelow',
        \   '<Plug>(Visual-Split',
        \ ] }

  " Always show signs column with marks / vcs / qf
  Plug 'tomtom/quickfixsigns_vim'

  " Disabled, not worth the overhead.
  " Alternatively use sjl/vitality.vim -- but that has some cursor shape stuff
  " that Neovim doesn't need.
  " @see <https://github.com/sjl/vitality.vim/issues/31>
  "Plug 'tmux-plugins/vim-tmux-focus-events'

  Plug g:dko#vim_dir . '/mine/vim-dko-line'
endfunction

" Similar but safer than Cond() from
" <https://github.com/junegunn/vim-plug/wiki/faq>
" This is a global function for command access
function! PlugIf(condition, ...) abort
  let l:enabled = a:condition ? {} : { 'on': [], 'for': [] }
  return a:0 ? extend(l:enabled, a:000[0]) : l:enabled
endfunction

" ============================================================================
" vim-plug helpers
" ============================================================================

" Memory cache
" List of loaded plug names
let s:loaded = []

" @param  {String} name
" @return {Boolean} true if the plugin is installed
function! dkoplug#plugins#Exists(name) abort
  return index(g:plugs_order, a:name) > -1
endfunction

" @param  {String} name
" @return {String} path where plugin installed
function! dkoplug#plugins#Dir(name) abort
  return dkoplug#plugins#Exists(a:name) ? g:plugs[a:name].dir : ''
endfunction

" @param  {String} name
" @return {Boolean} true if the plugin is actually loaded
function! dkoplug#plugins#IsLoaded(name) abort
  if index(s:loaded, a:name) > -1
    return 1
  endif

  let l:plug_dir = dkoplug#plugins#Dir(a:name)
  if empty(l:plug_dir)  || !isdirectory(l:plug_dir)
    return 0
  endif

  let l:is_loaded = empty(l:plug_dir)
        \ ? 0
        \ : stridx(&runtimepath, l:plug_dir) > -1

  if l:is_loaded
    call add(s:loaded, a:name)
  endif

  return l:is_loaded
endfunction

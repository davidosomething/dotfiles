" autoload/dkoplug/plugins.vim

" Similar but safer than Cond() from
" <https://github.com/junegunn/vim-plug/wiki/faq>
" This is a global function for command access
function! PlugIf(condition, ...) abort
  let l:enabled = a:condition ? {} : { 'on': [], 'for': [] }
  return a:0 ? extend(l:enabled, a:000[0]) : l:enabled
endfunction

" Shortcut
function! WithCompl(...) abort
  return call('PlugIf', [ g:dko_use_completion ] + a:000)
endfunction

function! dkoplug#plugins#LoadAll() abort
  " Notes on adding plugins:
  " - Absolutely do not use 'for' if the plugin provides an `ftdetect/`

  " ==========================================================================
  " Vim debugging
  " ==========================================================================

  " Show slow plugins
  Plug 'tweekmonster/startuptime.vim', { 'on': [ 'StartupTime' ] }

  " `:Bufferize messages` to get messages (or any :command) in a new buffer
  let g:bufferize_command = 'tabnew'
  Plug 'AndrewRadev/bufferize.vim', { 'on': [ 'Bufferize' ] }

  Plug 'cocopon/colorswatch.vim'
  Plug 'cocopon/pgmnt.vim'

  " Mostly for zS to debug highlight group (:Bufferize scriptnames is nicer
  " than :Scriptnames)
  Plug 'tpope/vim-scriptease'

  " ==========================================================================
  " Colorscheme
  " ==========================================================================

  Plug g:dko#vim_dir . '/mine/vim-meh'
  Plug 'rakr/vim-two-firewatch'
  Plug 'kamwitsta/flatwhite-vim'

  " ==========================================================================
  " Embedded filetype support
  " ==========================================================================

  " tyru/caw.vim, some others use this to determine inline embedded filetypes
  Plug 'Shougo/context_filetype.vim'

  " ==========================================================================
  " File system, ctags
  " ==========================================================================

  " Store accessed files in redis
  Plug 'neoclide/redismru.vim', PlugIf(executable('redis-cli'), {
        \   'do': 'npm install --force',
        \ })

  Plug 'ludovicchabant/vim-gutentags', PlugIf(executable('ctags'))

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
          \   'FZFRedisMRU',
          \   'FZFRelevant',
          \   'FZFTests',
          \   'FZFVim',
          \ ] })
  endif

  " gK to lookup
  Plug 'keith/investigate.vim'

  "Plug 'lambdalisue/gina.vim', PlugIf(exists('v:null'))

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

  "Plug 'sgur/vim-editorconfig'

  " highlight matching html tag
  Plug 'gregsexton/MatchTag'

  " add gS on char to smart split lines at char, like comma lists and html tags
  Plug 'AndrewRadev/splitjoin.vim'

  " Compatible with Neovim or Vim with this patch level
  Plug 'neomake/neomake', PlugIf(has('patch-7.4.503'))
  "Plug '~/projects/neomake'

  " ==========================================================================
  " Editing keys
  " ==========================================================================

  Plug 'cyansprite/Extract', PlugIf(has('nvim'))

  Plug 'godlygeek/tabular', { 'on': [ 'Tabularize' ] }

  Plug 'bootleq/vim-cycle', { 'on': [ '<Plug>Cycle' ] }

  Plug 'tpope/vim-repeat'

  " []-bindings -- buffer switch, lnext/prev, etc.
  " My fork has a lot of removals like line movement and entities
  Plug 'davidosomething/vim-unimpaired'

  " used for line bubbling commands (instead of unimpared!)
  " Consider also t9md/vim-textmanip
  Plug 'matze/vim-move'

  Plug 'kana/vim-operator-user'
  " gcc to toggle comment
  Plug 'tyru/caw.vim', { 'on': [ '<Plug>(caw' ] }
  " <Leader>s(a/r/d) to modify surrounding the pending operator
  Plug 'rhysd/vim-operator-surround', { 'on': [ '<Plug>(operator-surround' ] }
  " <Leader>c to toggle CamelCase/snak_e the pending operator
  Plug 'tyru/operator-camelize.vim', { 'on': [ '<Plug>(operator-camelize' ] }

  " Some textobjs are lazy loaded since they are ~4ms slow to load.
  " See plugin/textobj.vim to see how they're mapped.
  " -       Base textobj plugin
  Plug 'kana/vim-textobj-user'
  " - d/D   for underscore section (e.g. `did` on foo_b|ar_baz -> foo__baz)
  Plug 'machakann/vim-textobj-delimited', { 'on': [
        \   '<Plug>(textobj-delimited'
        \ ] }
  " - i     for indent level
  Plug 'kana/vim-textobj-indent', { 'on': [ '<Plug>(textobj-indent' ] }
  " - l     for current line
  Plug 'kana/vim-textobj-line', { 'on': [ '<Plug>(textobj-line' ] }
  " - P     for last paste
  Plug 'gilligan/textobj-lastpaste', { 'on': [ '<Plug>(textobj-lastpaste' ] }
  " - u     for url
  Plug 'mattn/vim-textobj-url', { 'on': [ '<Plug>(textobj-url' ] }
  " - b     for any block type (parens, braces, quotes, ltgt)
  Plug 'rhysd/vim-textobj-anyblock'
  " - x     for xml attr like `data-content="everything"`
  Plug 'whatyouhide/vim-textobj-xmlattr', { 'on': [
        \   '<Plug>(textobj-xmlattr',
        \ ] }

  " HR with <Leader>f[CHAR]
  Plug g:dko#vim_dir . '/mine/vim-hr'

  " <Leader>C <Plug>(dkosmallcaps)
  Plug g:dko#vim_dir . '/mine/vim-smallcaps', { 'on': [
        \   '<Plug>(dkosmallcaps)',
        \ ] }

  " Toggle movement mode line-wise/display-wise
  Plug g:dko#vim_dir . '/mine/vim-movemode'

  " ==========================================================================
  " Completion
  " ==========================================================================

  " --------------------------------------------------------------------------
  " Snippet engine
  " --------------------------------------------------------------------------

  Plug 'Shougo/neosnippet', WithCompl()
  Plug 'Shougo/neosnippet-snippets', WithCompl()
  Plug 'honza/vim-snippets', WithCompl()

  " --------------------------------------------------------------------------
  " Completion engine
  " --------------------------------------------------------------------------

  Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

  " --------------------------------------------------------------------------
  " Completion libraries
  " --------------------------------------------------------------------------

  " Include completion, include tags
  " For what langs are supported, see:
  " https://github.com/Shougo/neoinclude.vim/blob/master/autoload/neoinclude.vim
  Plug 'Shougo/neoinclude.vim', WithCompl()

  " --------------------------------------------------------------------------
  " Completion: Syntax
  " --------------------------------------------------------------------------

  " Full syntax completion. Keyed as [S]
  Plug 'Shougo/neco-syntax', WithCompl()

  " --------------------------------------------------------------------------
  " Completion: VimL
  " --------------------------------------------------------------------------

  Plug 'Shougo/neco-vim', WithCompl()
  Plug 'neoclide/coc-neco', WithCompl()

  " ==========================================================================
  " Multiple languages
  " ==========================================================================

  Plug 'itchyny/vim-parenmatch'

  " special end syntax for various langs
  Plug 'tpope/vim-endwise'

  " ==========================================================================
  " Language: ansible config
  " ==========================================================================

  " ft specific stuff only
  Plug 'pearofducks/ansible-vim'

  " ==========================================================================
  " Language: bash/shell/zsh
  " ==========================================================================

  " Upstreams
  Plug 'chrisbra/vim-sh-indent'
  Plug 'chrisbra/vim-zsh'

  " ==========================================================================
  " Language: D
  " ==========================================================================

  Plug 'idanarye/vim-dutyl', { 'for': [ 'd' ] }

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
  "Plug 'othree/html5.vim'

  "Plug 'tpope/vim-haml'

  " Creates html.handlebars and other fts and sets syn
  Plug 'mustache/vim-mustache-handlebars'

  " ==========================================================================
  " Language: JavaScript and derivatives, JSON
  " ==========================================================================

  Plug g:dko#vim_dir . '/mine/vim-pj'

  Plug 'elzr/vim-json'

  " provides coffee ft
  "Plug 'kchmck/vim-coffee-script', { 'for': [ 'coffee' ] }
  " The upstream has after/* garbage that messes with <script> html blocks in
  " php files
  Plug 'davidosomething/vim-coffee-script', {
        \   'for':    [ 'coffee' ],
        \   'branch': 'noft'
        \ }

  " TypeScript
  Plug 'leafgarland/typescript-vim'
  " Alternatively
  "Plug 'HerringtonDarkholme/yats.vim'

  " ----------------------------------------
  " Syntax
  " ----------------------------------------

  " Common settings for vim-javascript, vim-jsx-improve
  " let g:javascript_plugin_flow = 0
  let g:javascript_plugin_jsdoc = 1

  " COMBINED AND MODIFIED pangloss + vim-jsx-pretty
  " Not well maintained
  Plug 'neoclide/vim-jsx-improve'

  " PANGLOSS MODE - this is vim upstream now!
  " 1.  Preferring pangloss for now since I like the included indentexpr
  "     it also has a node ftdetect
  " 2.  After syntax, ftplugin, indent for JSX
  " Plug 'pangloss/vim-javascript'

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
  " JSX
  " ----------------------------------

  " Works with both pangloss/othree
  " Offers inline code highlighting in JSX blocks, as well as vim-jsx's hi
  " Plug 'maxmellon/vim-jsx-pretty'

  " ALTERNATE, original
  "Plug 'mxw/vim-jsx'

  " ----------------------------------
  " Template strings
  " ----------------------------------

  " `:JsPreTmpl html` to highlight `<div></div>` template strings
  "Plug 'Quramy/vim-js-pretty-template'

  " ----------------------------------
  " GraphQL
  " ----------------------------------

  Plug 'jparise/vim-graphql'

  " ==========================================================================
  " Language: Markdown, Pandoc
  " ==========================================================================

  " Override vim included markdown ft* and syntax
  " The git repo has a newer syntax file than the one that ships with vim
  Plug 'tpope/vim-markdown'

  " after/syntax for GitHub emoji, checkboxes
  Plug 'rhysd/vim-gfm-syntax'

  " Enable pandoc filetype options and vim operators/fns
  " Plug 'vim-pandoc/vim-pandoc', PlugIf(v:version >= 704)

  " Use pandoc for markdown syntax
  " Plug 'vim-pandoc/vim-pandoc-syntax'

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

  " Updated for php 7.1, Apr 2018 (newer than neovim 3.0 runtime)
  Plug 'StanAngeloff/php.vim', { 'for': [ 'php' ] }

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

  Plug 'lambdalisue/vim-pyenv', { 'for': [ 'python' ] }
  Plug 'Vimjas/vim-python-pep8-indent'

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

  " Upstream Neovim uses https://github.com/genoma/vim-less
  "   - more groups
  "   - no conflict with vim-css-color

  "Plug 'groenewege/vim-less'
  " - the syntax file here is actually older than genoma
  " - creates less filetype
  " - Conflicts with vim-css-color

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

  " Older syntax but has neat features
  "Plug 'tmux-plugins/vim-tmux'
  " Less feature filled but this is upstream for $VIMRUNTIME and more up-to-date
  Plug 'ericpruitt/tmux.vim', { 'rtp': 'vim/' }

  " ==========================================================================
  " Language: VimL
  " ==========================================================================

  Plug 'machakann/vim-vimhelplint'

  " gf to go to where autoloaded function is defined
  Plug 'kana/vim-gf-user', { 'for': [ 'vim' ] }
  Plug 'sgur/vim-gf-autoload', { 'for': [ 'vim' ] }

  Plug 'junegunn/vader.vim'

  " Auto-prefix continuation lines with \
  Plug 'lambdalisue/vim-backslash'

  "Plug 'syngan/vim-vimlint', PlugIf(executable('vimlparser'))

  " ==========================================================================
  " Search
  " See after/plugin/search.vim for complex configuration
  " ==========================================================================

  " <Plug> to not move on * search function
  Plug 'haya14busa/vim-asterisk'

  " Provides:
  " - Highlight partial matches as you type in search mode
  " - Stay cursor on first match slash '/' search
  " [DEPRECATED] Use native incsearch instead if has('patch-8.0.1238')
  " [BUG] Double cmdline cursor
  " - <https://github.com/haya14busa/incsearch.vim/issues/79>
  " - <https://github.com/neovim/neovim/issues/3688>
  "Plug 'haya14busa/incsearch.vim', PlugIf(v:version >= 704)

  " Show (#/total results) when searching for a term
  " known echo issue if remapping [[ and ]], but I removed that map
  " @see https://github.com/osyo-manga/vim-anzu/issues/19
  "Plug 'osyo-manga/vim-anzu'

  " ==========================================================================
  " UI -- load last!
  " ==========================================================================

  " --------------------------------------------------------------------------
  " VCS signs
  " --------------------------------------------------------------------------

  " Super slow start
  "Plug 'chrisbra/changesPlugin', PlugIf(v:version >= 800)
  " Slow start
  "Plug 'airblade/vim-gitgutter', { 'on': [ 'GitGutterToggle' ] }
  " Significatly faster than quickfixsigns_vim and the above
  Plug 'mhinz/vim-signify'

  " --------------------------------------------------------------------------
  " Quickfix window
  " --------------------------------------------------------------------------

  Plug 'blueyed/vim-qf_resize'
  Plug 'romainl/vim-qf'

  " --------------------------------------------------------------------------
  " Multi sign column
  " --------------------------------------------------------------------------

  " Always show signs column with marks
  "Too many features, slow start
  "Plug 'tomtom/quickfixsigns_vim'
  "Still slowish but better
  Plug 'kshenoy/vim-signature'

  " --------------------------------------------------------------------------
  " Window events
  " --------------------------------------------------------------------------

  " Disabled, not worth the overhead.
  " Alternatively use sjl/vitality.vim -- but that has some cursor shape stuff
  " that Neovim doesn't need.
  " @see <https://github.com/sjl/vitality.vim/issues/31>
  "Plug 'tmux-plugins/vim-tmux-focus-events'

  Plug 'wellle/visual-split.vim', { 'on': [
        \   'VSResize', 'VSSplit',
        \   'VSSplitAbove', 'VSSplitBelow',
        \   '<Plug>(Visual-Split',
        \ ] }

endfunction

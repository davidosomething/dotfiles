  " ==========================================================================
  " Commands
  " ==========================================================================

  let g:neoformat_enabled_json = [ 'dkoprettier', 'jq' ]
  let g:neoformat_enabled_java = [ 'uncrustify' ]
  let g:neoformat_enabled_javascript = [ 'eslint_d', 'standard' ]
  let g:neoformat_enabled_less = [ 'dkoprettier' ]
  let g:neoformat_enabled_lua = [ 'luafmt', 'luaformatter', 'stylua' ]
  let g:neoformat_enabled_markdown = []
  let g:neoformat_enabled_python = [ 'autopep8', 'isort' ]
  let g:neoformat_enabled_scss = [ 'dkoprettier' ]
  Plug 'sbdchd/neoformat'
  augroup dkoneoformat
    autocmd! FileType
        \ javascript,javascriptreact,typescript,typescriptreact
        \ nmap <silent> <A-e> :<C-u>Neoformat eslint_d<CR>
  augroup END

  " ==========================================================================
  " Input, syntax, spacing
  " ==========================================================================

  " highlight matching html/xml tag
  "Plug 'gregsexton/MatchTag'
  let g:matchup_delim_noskips = 2
  let g:matchup_matchparen_deferred = 1
  let g:matchup_matchparen_status_offscreen = 0
  Plug 'andymass/vim-matchup', PlugIf(has('patch-7.4.1689'))

  " add gS on char to smart split lines at char, like comma lists and html tags
  let g:splitjoin_trailing_comma = 0
  let g:splitjoin_ruby_trailing_comma = 1
  let g:splitjoin_ruby_hanging_args = 1
  Plug 'AndrewRadev/splitjoin.vim'

  " Compatible with Neovim or Vim with this patch level
  Plug 'neomake/neomake', PlugIf(has('patch-7.4.503'))

  " ==========================================================================
  " Editing keys
  " ==========================================================================

  " filetype custom [[ and ]] jumping
  Plug 'arp242/jumpy.vim'

  Plug 'bootleq/vim-cycle', { 'on': [ '<Plug>Cycle' ] }

  "Plug 'tpope/vim-repeat'

  " []-bindings -- buffer switch, lnext/prev, etc.
  " My fork has a lot of removals like line movement and entities
  Plug 'davidosomething/vim-unimpaired'

  " --------------------------------------------------------------------------
  " Operators and Textobjs
  " --------------------------------------------------------------------------

  " sa/sr/sd operators and ib/ab textobjs
  Plug 'machakann/vim-sandwich'

  Plug 'kana/vim-operator-user'
  " <Leader>c to toggle PascalCase/snak_e the pending operator
  Plug 'tyru/operator-camelize.vim', { 'on': [ '<Plug>(operator-camelize' ] }

  " Some textobjs are lazy loaded since they are ~4ms slow to load.
  " See plugin/textobj.vim to see how they're mapped.
  " -       Base textobj plugin
  Plug 'kana/vim-textobj-user'
  " - i     for indent level
  Plug 'kana/vim-textobj-indent', { 'on': [ '<Plug>(textobj-indent' ] }
  " - P     for last paste
  Plug 'gilligan/textobj-lastpaste', { 'on': [ '<Plug>(textobj-lastpaste' ] }
  " - u     for url
  Plug 'mattn/vim-textobj-url', { 'on': [ '<Plug>(textobj-url' ] }

  " ==========================================================================
  " Completion
  " ==========================================================================

  " --------------------------------------------------------------------------
  " Snippet engine
  " Now using coc-snippets
  " --------------------------------------------------------------------------

  " Provides some ultisnips snippets for use with neosnippet or coc-snippets
  Plug 'honza/vim-snippets', WithCompl()

  " --------------------------------------------------------------------------
  " Completion engine
  " --------------------------------------------------------------------------

  " https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
  let g:coc_global_extensions = [
        \  'coc-calc',
        \  'coc-css',
        \  'coc-cssmodules',
        \  'coc-diagnostic',
        \  'coc-docker',
        \  'coc-docthis',
        \  'coc-eslint',
        \  'coc-git',
        \  'coc-go',
        \  'coc-html',
        \  'coc-json',
        \  'coc-markdownlint',
        \  'coc-prettier',
        \  'coc-pyright',
        \  'coc-sh',
        \  'coc-snippets',
        \  'coc-solargraph',
        \  'coc-sumneko-lua',
        \  'coc-tsserver',
        \  'coc-vimlsp',
        \  'coc-yaml',
        \  '@yaegassy/coc-tailwindcss3',
        \]
  " Not working
  "      \  'coc-python',
  "      \  'coc-java',
  " Doesn't redraw in sync with edits
  "\  'coc-highlight',
  Plug 'neoclide/coc.nvim', WithCompl({ 'branch': 'release' })

  " ==========================================================================
  " Multiple languages
  " ==========================================================================

  " not configurable for coc
  "Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
  "lua vim.diagnostic.config({ virtual_lines = { only_current_line = true } })

  Plug 'suy/vim-context-commentstring'


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

  " Freezes up on completion
  "Plug 'tjdevries/coc-zsh'

  " ==========================================================================
  " Language: Caddyfile
  " ==========================================================================

  Plug 'isobit/vim-caddyfile'

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

  " committia for git rebase -i
  "Plug 'hotwatermorning/auto-git-diff'

  " ==========================================================================
  " Language: HTML, XML, and generators: mustache, handlebars
  " ==========================================================================

  " Syntax enhancements and htmlcomplete#CompleteTags function override
  "Plug 'othree/html5.vim'

  " Creates html.handlebars and other fts and sets syn
  Plug 'mustache/vim-mustache-handlebars'

  " ==========================================================================
  " Language: JavaScript and derivatives, JSON
  " ==========================================================================

  Plug g:dko#vim_dir . '/mine/vim-pj'

  " Order of these two matters
  "Plug 'elzr/vim-json'
  Plug 'neoclide/jsonc.vim'

  Plug 'gutenye/json5.vim'

  " provides coffee ft
  "Plug 'kchmck/vim-coffee-script', { 'for': [ 'coffee' ] }
  " The upstream has after/* garbage that messes with <script> html blocks in
  " php files
  Plug 'davidosomething/vim-coffee-script', {
        \   'for':    [ 'coffee' ],
        \   'branch': 'noft'
        \ }

  " TypeScript
  "Plug 'leafgarland/typescript-vim'
  " Alternatively
  Plug 'HerringtonDarkholme/yats.vim'

  " ----------------------------------------
  " Syntax
  " ----------------------------------------

  " Common settings for vim-javascript, vim-jsx-improve
  " let g:javascript_plugin_flow = 0
  let g:javascript_plugin_jsdoc = 1

  " COMBINED AND MODIFIED pangloss + vim-jsx-pretty
  " Not well maintained
  "Plug 'neoclide/vim-jsx-improve'

  " PANGLOSS MODE - this is vim upstream now!
  " 1.  Preferring pangloss for now since I like the included indentexpr
  "     it also has a node ftdetect
  " 2.  After syntax, ftplugin, indent for JSX
  Plug 'pangloss/vim-javascript'

  " YUEZK MODE - same maintainer as maxmellon/vim-jsx-pretty
  "Plug 'yuezk/vim-js'

  " YAJS MODE
  " 1.  yajs.vim highlighting is a little more robust than the pangloss one.
  " 2.  The libraries syntax adds unique highlighting for
  "     jQuery,backbone,etc. and I've confirmed it is only compatible with
  "     yajs.vim as of 2016-11-03.
  " 3.  es.next support has possible jsx indent conflicts
  "     https://github.com/othree/es.next.syntax.vim/issues/5
  " Plug 'othree/yajs.vim'
  " Plug 'othree/javascript-libraries-syntax.vim'
  " Plug 'othree/es.next.syntax.vim'

  " ----------------------------------
  " JSX
  " ----------------------------------

  " Works with both pangloss/othree
  " Offers inline code highlighting in JSX blocks, as well as vim-jsx's hi
  Plug 'maxmellon/vim-jsx-pretty'

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
  " I'm using jumpy.vim for [[ and ]]
  let g:no_markdown_maps = 1
  Plug 'tpope/vim-markdown'

  " after/syntax for GitHub emoji, checkboxes
  Plug 'rhysd/vim-gfm-syntax'

  " Enable pandoc filetype options and vim operators/fns
  " Plug 'vim-pandoc/vim-pandoc', PlugIf(v:version >= 704)

  " Use pandoc for markdown syntax
  " Plug 'vim-pandoc/vim-pandoc-syntax'

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

  " Updated for php 7.3 Mar 2019 (newer than neovim 5.0 runtime)
  Plug 'StanAngeloff/php.vim', { 'for': [ 'php' ] }

  " Indent
  " 2072 is included with vim, this is upstream
  Plug '2072/PHP-Indenting-for-VIm'

  " ==========================================================================
  " Language: Python
  " ==========================================================================

  " Vim's python ftplugin upstream
  " Not a valid plugin runtime structure, file needs to be in ftplugin/
  "Plug 'sullyj3/vim-ftplugin-python'

  "Plug 'lambdalisue/vim-pyenv', { 'for': [ 'python' ] }
  Plug 'Vimjas/vim-python-pep8-indent'

  Plug 'vim-python/python-syntax'

  " ==========================================================================
  " Language: QML
  " ==========================================================================

  Plug 'peterhoeg/vim-qml'

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
  " Language: Starlark
  " ==========================================================================

  Plug 'cappyzawa/starlark.vim'

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

  " ==========================================================================
  " Language: TOML
  " ==========================================================================

  Plug 'cespare/vim-toml'

  " ==========================================================================
  " Language: VimL
  " vim-lookup and vim-vimlint replaced by coc-vimlsp
  " ==========================================================================

  Plug 'machakann/vim-vimhelplint'

endfunction

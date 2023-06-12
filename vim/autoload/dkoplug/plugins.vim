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
  " Fixes
  " ==========================================================================

  " Disable cursorline sometimes, for performance
  Plug 'delphinus/vim-auto-cursorline', PlugIf(exists('*timer_start'))

  " ==========================================================================
  " Vim debugging
  " ==========================================================================

  " Show slow plugins
  Plug 'tweekmonster/startuptime.vim', { 'on': [ 'StartupTime' ] }

  " `:Bufferize messages` to get messages (or any :command) in a new buffer
  let g:bufferize_command = 'tabnew'
  Plug 'AndrewRadev/bufferize.vim', { 'on': [ 'Bufferize' ] }

  " Required by Inspecthi, don't lazy
  Plug 'cocopon/colorswatch.vim'

  silent! nunmap zs
  nnoremap <silent> zs :<C-U>Inspecthi<CR>
  Plug 'cocopon/inspecthi.vim', { 'on': [ 'Inspecthi' ] }

  " ==========================================================================
  " Colorscheme
  " ==========================================================================

  let l:local_meh = expand('~/projects/davidosomething/vim-colors-meh')
  if isdirectory(l:local_meh)
    Plug l:local_meh
  else
    Plug 'davidosomething/vim-colors-meh'
  endif
  Plug 'rakr/vim-two-firewatch'
  Plug 'kamwitsta/flatwhite-vim'

  " ==========================================================================
  " Embedded filetype support
  " ==========================================================================

  " tyru/caw.vim, some others use this to determine inline embedded filetypes
  Plug 'Shougo/context_filetype.vim'

  " ==========================================================================
  " Commands
  " ==========================================================================

  " --------------------------------------------------------------------------
  " FZF
  " --------------------------------------------------------------------------

  " Use the repo instead of the version in brew since it includes the help
  " docs for fzf#run()
  Plug 'junegunn/fzf', PlugIf(g:dko_use_fzf)

  let g:fzf_command_prefix = 'FZF'
  let g:fzf_layout = extend({ 'down': '~40%' }, {})
  let g:fzf_buffers_jump = 1
  Plug 'junegunn/fzf.vim', PlugIf(g:dko_use_fzf)

  " --------------------------------------------------------------------------

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
    autocmd BufWritePre *.ts* Neoformat eslint_d
  augroup END


  " Add file manip commands like Remove, Move, Rename, SudoWrite
  " Do not lazy load, tracks buffers
  Plug 'tpope/vim-eunuch'

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

  " used for line bubbling commands (instead of unimpared!)
  " Consider also t9md/vim-textmanip
  Plug 'matze/vim-move'

  " HR with <Leader>f[CHAR]
  Plug g:dko#vim_dir . '/mine/vim-hr'

  " <Leader>C <Plug>(dkosmallcaps)
  Plug g:dko#vim_dir . '/mine/vim-smallcaps', { 'on': [
        \   '<Plug>(dkosmallcaps)',
        \ ] }

  " Toggle movement mode line-wise/display-wise
  Plug g:dko#vim_dir . '/mine/vim-movemode'

  " --------------------------------------------------------------------------
  " Operators and Textobjs
  " --------------------------------------------------------------------------

  " sa/sr/sd operators and ib/ab textobjs
  Plug 'machakann/vim-sandwich'

  Plug 'kana/vim-operator-user'
  " gcc to toggle comment
  Plug 'tyru/caw.vim', { 'on': [ '<Plug>(caw' ] }
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
  " Signature preview
  " --------------------------------------------------------------------------

  Plug 'Shougo/echodoc.vim'

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

  " show diff when editing a COMMIT_EDITMSG
  let g:committia_open_only_vim_starting = 0
  let g:committia_use_singlecolumn       = 'always'
  Plug 'rhysd/committia.vim'

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
  " Language: Lua
  " ==========================================================================

  Plug 'euclidianAce/BetterLua.vim'

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
  " Color highlighting
  " ==========================================================================

  " Alternatives:
  " - coc-highlight -- requires language server to support colors, can be slow

  " ==========================================================================
  " Language: TOML
  " ==========================================================================

  Plug 'cespare/vim-toml'

  " ==========================================================================
  " Language: VimL
  " vim-lookup and vim-vimlint replaced by coc-vimlsp
  " ==========================================================================

  Plug 'machakann/vim-vimhelplint'

  " Auto-prefix continuation lines with \
  " Error: <CR> recursive mapping
  " Plug 'lambdalisue/vim-backslash'

  " ==========================================================================
  " UI -- load last!
  " ==========================================================================

  Plug 'nathanaelkane/vim-indent-guides'

  " --------------------------------------------------------------------------
  " Quickfix window
  " --------------------------------------------------------------------------

  let g:qf_resize_min_height = 4
  Plug 'blueyed/vim-qf_resize'

  " --------------------------------------------------------------------------
  " Window events
  " --------------------------------------------------------------------------

  " <C-w>o to zoom in/out of a window
  "Plug 'dhruvasagar/vim-zoom'
  " Better zoom plugin, accounts for command window and doesn't use sessions
  Plug 'troydm/zoomwintab.vim'

  Plug 'wellle/visual-split.vim', { 'on': [
        \   'VSResize', 'VSSplit',
        \   'VSSplitAbove', 'VSSplitBelow',
        \   '<Plug>(Visual-Split',
        \ ] }

endfunction

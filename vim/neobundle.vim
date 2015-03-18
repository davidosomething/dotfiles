scriptencoding utf-8
" add scriptencoding explicitly on this plugin file since it uses funky chars

" Rules to adhere to:
" - If it provides a new filetype (like vim-coffee-script), don't lazy

" plugin dependencies ----------------------------------------------------------
NeoBundle 'Shougo/vimproc', {
      \   'build': {
      \     'mac':     'make -f make_mac.mak',
      \     'unix':    'make -f make_unix.mak',
      \     'cygwin':  'make -f make_cygwin.mak',
      \     'windows': 'make -f make_mingw32.mak',
      \   }
      \ }

NeoBundle 'tobyS/vmustache' " for pdv

" ui ---------------------------------------------------------------------------
NeoBundle 'altercation/vim-colors-solarized', {
      \   'disabled': !(has("gui") || has("gui_macvim")),
      \ }
if neobundle#tap('vim-colors-solarized')
  function! neobundle#tapped.hooks.on_source(bundle)
    set background=light
    silent! colorscheme solarized               " STFU if no solarized
    silent! call togglebg#map("<F5>")
  endfunction
  call neobundle#untap()
endif

NeoBundle 'bling/vim-airline', {
      \   'depends': 'tpope/vim-fugitive',
      \ }
if neobundle#tap('vim-airline')
  let g:airline_powerline_fonts = 1
  let g:airline_theme = "bubblegum"

  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  " line number symbol
  let g:airline_symbols.linenr = ''
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.readonly = ''

  let g:airline#extensions#quickfix#quickfix_text = 'QF'
  let g:airline#extensions#quickfix#location_text = 'LL'

  " list buffers ONLY at top
  let g:airline#extensions#tabline#enabled = 1
  " never show tabs
  let g:airline#extensions#tabline#show_tabs = 0
  " don't need to indicate whether showing buffers or tabs
  let g:airline#extensions#tabline#show_tab_type = 0
  " show superscript buffer numbers (buffer_nr_show is off)
  let g:airline#extensions#tabline#buffer_idx_mode = 1

  " disable extensions for speed
  let g:airline#extensions#bufferline#enabled = 0
  let g:airline#extensions#capslock#enabled   = 0
  let g:airline#extensions#csv#enabled        = 0
  let g:airline#extensions#eclim#enabled      = 0
  let g:airline#extensions#hunks#enabled      = 0
  let g:airline#extensions#nrrwrgn#enabled    = 0
  let g:airline#extensions#promptline#enabled = 0
  let g:airline#extensions#syntastic#enabled  = 0
  let g:airline#extensions#tagbar#enabled     = 0
  let g:airline#extensions#tmuxline#enabled   = 0
  let g:airline#extensions#virtualenv#enabled = 0
  let g:airline#extensions#whitespace#enabled = 0
  let g:airline#extensions#windowswap#enabled = 0
  call neobundle#untap()
endif

NeoBundle 'dockyard/vim-easydir'        " creates dir if new file in new dir

" auto tag generation via exuberant-ctags -- no tags file created
NeoBundleLazy 'majutsushi/tagbar', {
      \   'autoload': { 'commands': 'TagbarToggle' },
      \   'disabled': !executable("ctags"),
      \ }
if neobundle#tap('tagbar')
  nmap <F8> :TagbarToggle<CR>
  imap <F8> <Esc>:TagbarToggle<CR>
  vmap <F8> <Esc>:TagbarToggle<CR>

  let g:tagbar_autoclose = 1            " close after jumping
  let g:tagbar_autofocus = 1
  let g:tagbar_compact = 1
  let g:tagbar_show_linenumbers = 1     " Show absolute line numbers
endif

NeoBundle 'mhinz/vim-hugefile'          " disable vim features for large files

NeoBundle 'nathanaelkane/vim-indent-guides'
if neobundle#tap('vim-indent-guides')
  nnoremap <F7> :IndentGuidesToggle<CR>
  let g:indent_guides_guide_size = 1
  let g:indent_guides_start_level = 2
  call neobundle#untap()
endif

NeoBundle 'now/vim-quit-if-only-quickfix-buffer-left'

NeoBundle 'Shougo/unite.vim'

NeoBundleLazy 'Shougo/vimfiler.vim', {
      \   'autoload': { 'commands': ['VimFiler'] },
      \   'depends': 'Shougo/unite.vim',
      \ }
if neobundle#tap('vimfiler.vim')
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_tree_leaf_icon = ' '
  let g:vimfiler_tree_opened_icon = '▾'
  let g:vimfiler_tree_closed_icon = '▸'
  let g:vimfiler_file_icon = '-'
  let g:vimfiler_marked_file_icon = '*'
endif

NeoBundleLazy 'sjl/gundo.vim', {
      \   'autoload': { 'commands': [ 'GundoToggle' ] },
      \ }
if neobundle#tap('gundo.vim')
  nnoremap <F2> :GundoToggle<CR>
endif

NeoBundle 'suan/vim-instant-markdown', {
      \   'build': {
      \     'mac':     'npm install -g instant-markdown-d',
      \     'unix':    'npm install -g instant-markdown-d',
      \     'cygwin':  'npm install -g instant-markdown-d',
      \     'windows': 'npm install -g instant-markdown-d',
      \   }
      \ }

if neobundle#tap('gundo.vim')
  let g:instant_markdown_autostart = 0
  let g:instant_markdown_slow = 1
endif

NeoBundle 'tpope/vim-fugitive'

" ------------------------------------------------------------------------------
" commands
NeoBundleLazy 'haya14busa/incsearch.vim', {
      \   'autoload': { 'mappings': '<Plug>(incsearch-', },
      \ }
if neobundle#tap('incsearch.vim')
  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)
endif

NeoBundleLazy 'osyo-manga/vim-over', {
      \   'autoload': { 'commands': [ 'OverCommandLine' ] },
      \ }
if neobundle#tap('vim-over')
  nmap <F3> :OverCommandLine<CR>
  vmap <F3> <Esc>:OverCommandLine<CR>
endif

NeoBundleLazy 'rking/ag.vim', { 'autoload': { 'commands': 'Ag' } }

NeoBundle 'tpope/vim-eunuch'

NeoBundle 'tpope/vim-unimpaired'        " used for line bubbling commands on osx

" ------------------------------------------------------------------------------
" autocomplete

" detect filetype under cursor, e.g. inline JS and CSS in a PHP doc
NeoBundle 'Shougo/context_filetype.vim'

" Works with neocomplete --
" show function signatures in bottom of command line instead of in scratch
" buffer
" NeoBundle 'Shougo/echodoc', '', 'default'
" call neobundle#config('echodoc', {
"       \   'lazy': 1,
"       \   'autoload': { 'insert': 1, },
"       \ })
" if neobundle#tap('echodoc')
"   set cmdheight=2
"   let g:echodoc_enable_at_startup = 1
" endif

" neocomplete probably used on osx and on my arch
NeoBundleLazy 'Shougo/neocomplete.vim', {
      \   'autoload':     { 'insert': 1, },
      \   'disabled':     !has('lua'),
      \   'vim_version':  '7.3.885'
      \ }
if neobundle#tap('neocomplete.vim')
  let g:neocomplete#enable_at_startup            = 1
  let g:neocomplete#enable_smart_case            = 1
  let g:neocomplete#enable_camel_case            = 1
  let g:neocomplete#enable_fuzzy_completion      = 0
  let g:neocomplete#data_directory = '~/.vim/.cache/neocomplete'

  " completion sources
  let g:neocomplete#sources#syntax#min_keyword_length = 3

  " enable heavy completion
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif

  " CRASH HEAVY OMNICOMPLETE
  let g:neocomplete#sources#omni#input_patterns.ruby = ''
  let g:neocomplete#sources#omni#input_patterns.python = ''

  " from neocomplete docs -- phpcomplete.vim integration
  let g:neocomplete#sources#omni#input_patterns.php =
    \ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

  function! neobundle#tapped.hooks.on_source(bundle)
    " from the github page: <CR> cancels completion and inserts newline
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return neocomplete#close_popup() . "\<CR>"
    endfunction

    " These are in neocomplete#mappings#define_default_mappings()
    " <C-h>, <BS>: close popup and delete backword char.
    " inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    " inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  endfunction
  call neobundle#untap()
endif

NeoBundle 'Shougo/neocomplcache.vim', {
      \   'disabled':     has('lua') && v:version >= 703,
      \ }
if neobundle#tap('neocomplcache.vim')
  let g:neocomplcache_enable_at_startup             = 1
  let g:neocomplcache_enable_smart_case             = 1
  let g:neocomplcache_enable_camel_case_completion  = 1
  let g:neocomplcache_enable_underbar_completion    = 1
  let g:neocomplcache_enable_fuzzy_completion       = 1
  let g:neocomplcache_force_overwrite_completefunc  = 1
  let g:neocomplcache_temporary_dir = '~/.vim/.cache/neocomplcache'

  " Enable heavy omni completion.
  if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
  endif
  let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

  function! neobundle#tapped.hooks.on_source(bundle)
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><BS>   neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplcache#close_popup()
    inoremap <expr><C-e>  neocomplcache#cancel_popup()
  endfunction
  call neobundle#untap()
endif

" for both neocomplete and neocomplcache
if neobundle#is_installed('neocomplcache.vim') || neobundle#is_installed('neocomplete.vim')
  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0

  " don't open scratch preview
  set completeopt-=preview

  " select completion using tab
  inoremap <expr><Tab>      pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-Tab>    pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " completion
  au vimrc FileType css           setlocal omnifunc=csscomplete#CompleteCSS
  au vimrc FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  au vimrc FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
  au vimrc FileType python        setlocal omnifunc=pythoncomplete#Complete
  au vimrc FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
  au vimrc FileType ruby          setlocal omnifunc=rubycomplete#Complete
endif

" ------------------------------------------------------------------------------
" editing keys
NeoBundleLazy 'godlygeek/tabular', { 'autoload': { 'commands': 'Tabularize' } }
if neobundle#tap('tabular')
  nmap <Leader>a& :Tabularize /&<CR>
  vmap <Leader>a& :Tabularize /&<CR>
  nmap <Leader>a- :Tabularize /-<CR>
  vmap <Leader>a- :Tabularize /-<CR>
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>af :Tabularize /=>/<CR>
  vmap <Leader>af :Tabularize /=>/<CR>
  " align the following without moving them
  nmap <leader>a: :Tabularize /:\zs/l0l1<CR>
  vmap <leader>a: :Tabularize /:\zs/l0l1<CR>
  nmap <leader>a, :Tabularize /,\zs/l0l1<CR>
  vmap <leader>a, :Tabularize /,\zs/l0l1<CR>
  call neobundle#untap()
endif

NeoBundle 'svermeulen/vim-easyclip'
if neobundle#tap('vim-easyclip')
  " explicitly do NOT remap s/S to paste register
  let g:EasyClipUseSubstituteDefaults = 0
  " save yanks in a file and persist
  let g:EasyClipShareYanks = 1
  let g:EasyClipShareYanksDirectory = "$HOME/.vim"
  call neobundle#untap()
endif

NeoBundle 'nishigori/increment-activator' " custom C-x C-a mappings

NeoBundle 'tomtom/tcomment_vim'

NeoBundle 'tpope/vim-endwise'

NeoBundle 'tpope/vim-repeat'

NeoBundle 'tpope/vim-speeddating'       " fast increment datetimes

NeoBundle 'tpope/vim-surround'

NeoBundle 'vim-scripts/AnsiEsc.vim'

" ------------------------------------------------------------------------------
" text objects
NeoBundle 'kana/vim-textobj-user'             " framework

" provide iv av for camel and snake case segments auto-determined
NeoBundle 'Julian/vim-textobj-variable-segment', {
      \   'depends': 'kana/vim-textobj-user'
      \ }

" provide ai and ii for indent blocks
NeoBundle 'kana/vim-textobj-indent', { 'depends': 'kana/vim-textobj-user' }

" provide al and il for current line
NeoBundle 'kana/vim-textobj-line', { 'depends': 'kana/vim-textobj-user' }

" provide a_ and i_ for underscores
NeoBundle 'lucapette/vim-textobj-underscore', {
      \   'depends': 'kana/vim-textobj-user',
      \ }

" provide al and il for current line
NeoBundle 'mattn/vim-textobj-url', { 'depends': 'kana/vim-textobj-user' }

" provide {, ", ', [, <, various other block objects
NeoBundle 'paradigm/TextObjectify'

" provide a- and i-
NeoBundle 'RyanMcG/vim-textobj-dash', { 'depends': 'kana/vim-textobj-user' }

" ------------------------------------------------------------------------------
" syntax highlighting
NeoBundle 'editorconfig/editorconfig-vim', {
      \   'depends': 'vim-scripts/PreserveNoEOL',
      \   'disabled': !(has("python") || has("python3")),
      \ }

" highlight matching html tag
NeoBundleLazy 'gregsexton/MatchTag', {
      \   'autoload': { 'filetypes': ['html', 'mustache', 'php', 'rb'] },
      \ }

NeoBundle 'scrooloose/syntastic'
if neobundle#tap('syntastic')
  let g:syntastic_aggregate_errors         = 1
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list            = 1
  let g:syntastic_check_on_open            = 1
  let g:syntastic_check_on_wq              = 0
  let g:syntastic_enable_signs             = 1
  let g:syntastic_enable_highlighting      = 1
  let g:syntastic_loc_list_height          = 3

  if !exists("g:syntastic_mode_map")
    let g:syntastic_mode_map = {}
  endif
  if !has_key(g:syntastic_mode_map, "mode")
    let g:syntastic_mode_map['mode'] = 'active'
  endif
  if !has_key(g:syntastic_mode_map, "active_filetypes")
    let g:syntastic_mode_map['active_filetypes'] = []
  endif
  if !has_key(g:syntastic_mode_map, "passive_filetypes")
    let g:syntastic_mode_map['passive_filetypes'] = [ 'html', 'php', ]
  endif

  let g:syntastic_error_symbol         = '✗'
  let g:syntastic_style_error_symbol   = '✠'
  let g:syntastic_warning_symbol       = '∆'
  let g:syntastic_style_warning_symbol = '≈'

  " ignore angular attrs
  let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

  let g:syntastic_coffeescript_checkers = ['coffee', 'coffeelint']
  let g:syntastic_php_checkers = ['php', 'phpmd']
  let g:syntastic_python_checkers = ['flake8']
  let g:syntastic_shell_checkers = ['bashate', 'shellcheck']
  call neobundle#untap()
endif

NeoBundle 'vim-scripts/PreserveNoEOL'

" ------------------------------------------------------------------------------
" Language specific
"
" Git --------------------------------------------------------------------------
NeoBundle 'tpope/vim-git'               " creates gitconfig, gitcommit, rebase

" HTML and generators ----------------------------------------------------------
NeoBundleLazy 'othree/html5.vim', {
      \   'autoload': { 'filetypes': ['css', 'html', 'php'] },
      \ }

NeoBundleLazy 'digitaltoad/vim-jade', { 'autoload': { 'filetypes': ['jade'] } }

NeoBundle 'tpope/vim-haml'              " creates haml, sass, scss filetypes

" JavaScript / CoffeeScript ----------------------------------------------------
NeoBundleLazy 'heavenshell/vim-jsdoc', {
      \   'autoload': {
      \     'filetypes': ['html', 'javascript', 'php'],
      \     'commands': ['JsDoc'],
      \   }
      \ }
if neobundle#tap('vim-jsdoc')
  let g:jsdoc_default_mapping = 0
  if has("autocmd")
    au vimrc FileType javascript nnoremap <Leader>pd :JsDoc<CR>
    au vimrc FileType javascript vnoremap <Leader>pd :JsDoc<CR>
  endif
  call neobundle#untap()
endif

NeoBundleLazy 'itspriddle/vim-jquery', {
      \   'autoload': { 'filetypes': ['html', 'javascript', 'php'] }
      \ }

NeoBundleLazy 'jelera/vim-javascript-syntax', {
      \   'autoload': { 'filetypes': ['html', 'javascript', 'php'] }
      \ }

" can't lazy this, provides coffee ft
NeoBundle 'kchmck/vim-coffee-script'
if neobundle#tap('vim-coffee-script')
  let g:coffee_compile_vert = 1
  let g:coffee_watch_vert = 1
  call neobundle#untap()
endif

" tagbar ctags for coffee
NeoBundle 'lukaszkorecki/CoffeeTags', {
      \   'depends' : 'majutsushi/tagbar',
      \   'disabled': !executable("coffeetags"),
      \ }
if neobundle#tap('CoffeeTags')
  let g:CoffeeAutoTagFile="$HOME/.vim/.tags/tags"
  " let g:tagbar_type_coffee = {
  "       \   'ctagsbin': 'coffeetags',
  "       \   'ctagsargs': '',
  "       \   'kinds': [
  "       \     'f:functions',
  "       \     'o:object',
  "       \   ],
  "       \   'sro': ".",
  "       \   'kind2scope' : {
  "       \     'f': 'object',
  "       \     'o': 'object',
  "       \   }
  "       \ }
endif

" react/JSX syn highlighting for .jsx
NeoBundleLazy 'mxw/vim-jsx', { 'depends': 'vim-javascript' }

NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {
      \   'autoload': { 'filetypes': ['javascript', 'coffee'] }
      \ }

NeoBundleLazy 'pangloss/vim-javascript', {
      \   'autoload': { 'filetypes': ['html', 'javascript', 'php'] }
      \ }
if neobundle#tap('vim-javascript')
  let g:javascript_enable_domhtmlcss=1
  call neobundle#untap()
endif

" JSON -------------------------------------------------------------------------
NeoBundleLazy 'elzr/vim-json', { 'autoload': { 'filetypes': ['json'] } }
if neobundle#tap('vim-json')
  let g:vim_json_syntax_conceal = 0
  if has("autocmd")
    " JSON force JSON not javascript
    au vimrc BufRead,BufNewFile *.json setlocal filetype=json
  endif
  call neobundle#untap()
endif

" Mustache.js and Handlebars ---------------------------------------------------
NeoBundleLazy 'mustache/vim-mustache-handlebars', {
      \   'autoload' : { 'filetypes': ['html', 'mustache', 'hbs'] },
      \ }

" PHP --------------------------------------------------------------------------
NeoBundleLazy 'tobyS/pdv', {
      \   'autoload': { 'filetypes': ['php', 'blade'] },
      \   'depends': 'tobyS/vmustache',
      \ }
if neobundle#tap('pdv')
  let g:pdv_template_dir = expand("~/.vim/bundle/pdv/templates")
  if has("autocmd")
    au vimrc FileType php nnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>
    au vimrc FileType php vnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>
  endif
  call neobundle#untap()
endif

NeoBundleLazy 'shawncplus/phpcomplete.vim', {
      \   'autoload': { 'filetypes': ['php', 'blade'] },
      \ }
if neobundle#tap('phpcomplete.vim')
  " mapping conflict with vim-rails, change <C-]> to <C-)>
  let g:phpcomplete_enhance_jump_to_definition = 0
  let g:phpcomplete_parse_docblock_comments = 1
  call neobundle#untap()
endif

" provides updated syntax
NeoBundleLazy 'StanAngeloff/php.vim', {
      \   'autoload': { 'filetypes': ['php', 'blade'] },
      \ }

NeoBundleLazy 'vim-php/tagbar-phpctags.vim', {
      \   'autoload': { 'filetypes': ['php', 'blade'] },
      \   'build': {
      \     'mac': 'make',
      \     'unix': 'make',
      \    },
      \   'depends' : 'majutsushi/tagbar',
      \   'disabled': !executable("ctags"),
      \ }

" Ruby, rails, chef, puppet ----------------------------------------------------
NeoBundle 'rodjek/vim-puppet'           " creates pp filetype

NeoBundleLazy 'vadv/vim-chef', {
      \   'autoload': { 'filetypes': ['ruby', 'eruby'] },
      \ }

NeoBundle 'vim-ruby/vim-ruby'           " creates ruby filetype

" Stylesheet languages ---------------------------------------------------------
NeoBundle 'ap/vim-css-color'

NeoBundle 'cakebaker/scss-syntax.vim'   " creates scss.css

NeoBundle 'groenewege/vim-less'         " creates less filetype

NeoBundleLazy 'hail2u/vim-css3-syntax', {
      \   'autoload': { 'filetypes': ['css', 'scss'] },
      \ }
if neobundle#tap('vim-css3-syntax')
  if has("autocmd")
    augroup VimCSS3Syntax
      autocmd!
      autocmd FileType css setlocal iskeyword+=-
    augroup END
  endif
endif

" Twig -------------------------------------------------------------------------
NeoBundle 'evidens/vim-twig'            " creates twig

" YAML -------------------------------------------------------------------------
NeoBundle 'ingydotnet/yaml-vim'

" vim: set ft=vim :

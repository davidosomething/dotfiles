scriptencoding UTF-8

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin dependencies

NeoBundle 'kana/vim-operator-user', {
      \   'autoload' : {
      \     'functions' : 'operator#user#define'
      \   }
      \ }

NeoBundle 'MarcWeber/vim-addon-mw-utils'

NeoBundle 'Shougo/vimproc', {
      \   'build': {
      \     'mac':     'make -f make_mac.mak',
      \     'unix':    'make -f make_unix.mak',
      \     'cygwin':  'make -f make_cygwin.mak',
      \     'windows': 'make -f make_mingw32.mak',
      \   }
      \ }

NeoBundle 'tobyS/vmustache'

NeoBundle 'tomtom/tlib_vim'

" filesystem """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

NeoBundle 'vim-scripts/PreserveNoEOL'

" ui """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'altercation/vim-colors-solarized'

NeoBundle 'bling/vim-airline', {
      \   'depends': 'tpope/vim-fugitive'
      \ }
if neobundle#tap('vim-airline')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:airline_powerline_fonts = 1
    let g:airline_theme= "bubblegum"

    if !exists('g:airline_symbols')
      let g:airline_symbols = {}
    endif
    let g:airline_symbols.linenr = ''
    let g:airline_symbols.paste = 'ρ'
    let g:airline_symbols.readonly = ''

    " list tabs/buffers at top
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#show_tabs = 0
    let g:airline#extensions#tabline#show_tab_nr = 0

    " disable extensions for speed
    let g:airline#extensions#tagbar#enabled = 0
    let g:airline#extensions#csv#enabled = 0
    let g:airline#extensions#hunks#enabled = 0
    let g:airline#extensions#virtualenv#enabled = 0
    let g:airline#extensions#eclim#enabled = 0
    let g:airline#extensions#whitespace#enabled = 0
    let g:airline#extensions#nrrwrgn#enabled = 0
    let g:airline#extensions#capslock#enabled = 0
    let g:airline#extensions#windowswap#enabled = 0
  endfunction
  call neobundle#untap()
endif

NeoBundle 'dockyard/vim-easydir'        " creates dir if new file in new dir

"NeoBundle 'dbarsam/vim-bufkill'         " :bd keeps window open

" auto tag generation via exuberant-ctags -- no tags file created
NeoBundle 'majutsushi/tagbar', {
      \   'disabled': !executable("ctags"),
      \ }
if neobundle#tap('tagbar')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:tagbar_compact = 1
    let g:tagbar_show_linenumbers = 1     " Show absolute line numbers
    nmap <F8> :TagbarToggle<CR>
  endfunction
endif

NeoBundle 'mhinz/vim-hugefile'          " disable vim features for large files

NeoBundle 'nathanaelkane/vim-indent-guides'
if neobundle#tap('vim-indent-guides')
  function! neobundle#tapped.hooks.on_source(bundle)
    nnoremap <F7> :IndentGuidesToggle<CR>
    let g:indent_guides_guide_size = 1
    let g:indent_guides_start_level = 2
  endfunction
  call neobundle#untap()
endif

NeoBundle 'tpope/vim-fugitive'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" commands
NeoBundle 'haya14busa/incsearch.vim', {
      \   'autoload': { 'mappings': '<Plug>(incsearch-', },
      \ }
if neobundle#tap('incsearch.vim')
  function! neobundle#tapped.hooks.on_source(bundle)
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
  endfunction
endif

NeoBundle 'rking/ag.vim'

NeoBundle 'tpope/vim-eunuch'

NeoBundle 'tpope/vim-unimpaired'        " used for line bubbling commands on osx

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocomplete
" neocomplete probably used on osx and on my arch
NeoBundleLazy 'Shougo/neocomplete.vim', {
      \   'autoload':     { 'insert': 1, },
      \   'disabled':     !has('lua'),
      \   'vim_version':  '7.3.885'
      \ }
if neobundle#tap('neocomplete.vim')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_at_startup            = 1
    let g:neocomplete#enable_smart_case            = 1
    let g:neocomplete#enable_camel_case_completion = 1
    let g:neocomplete#enable_underbar_completion   = 1
    let g:neocomplete#enable_fuzzy_completion      = 1
    let g:neocomplete#force_overwrite_completefunc = 1
    let g:neocomplete#enable_refresh_always        = 1
    let g:neocomplete#data_directory = '~/.vim/.cache/neocomplete'

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
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:acp_enableAtStartup = 0
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

    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplcache#close_popup()
    inoremap <expr><C-e>  neocomplcache#cancel_popup()
  endfunction
  call neobundle#untap()
endif

  " for both neocomplete and neocomplcache
    " select completion using tab
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" editing keys
NeoBundle 'godlygeek/tabular', {'autoload':{'commands':'Tabularize'}}
if neobundle#tap('tabular')
  function! neobundle#tapped.hooks.on_source(bundle)
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
  endfunction
  call neobundle#untap()
endif

NeoBundle 'svermeulen/vim-easyclip'
if neobundle#tap('vim-easyclip')
  function! neobundle#tapped.hooks.on_source(bundle)
    " vim just uses system clipboard
    let g:EasyClipDoSystemSync = 0
    " remap s/S to paste register
    let g:EasyClipUseSubstituteDefaults = 1
  endfunction
  call neobundle#untap()
endif

NeoBundle 'nishigori/increment-activator' " custom C-x C-a mappings

NeoBundle 'tomtom/tcomment_vim'

NeoBundle 'tpope/vim-endwise'

NeoBundle 'tpope/vim-repeat'

NeoBundle 'tpope/vim-speeddating'       " fast increment datetimes

NeoBundle 'tpope/vim-surround'

NeoBundle 'vim-scripts/AnsiEsc.vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" text objects
NeoBundle 'kana/vim-textobj-indent', {
      \   'depends': 'kana/vim-textobj-user',
      \ }

NeoBundle 'kana/vim-textobj-user'             " framework

NeoBundle 'lucapette/vim-textobj-underscore', {
      \   'depends': 'kana/vim-textobj-user',
      \ }

NeoBundle 'paradigm/TextObjectify'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntax highlighting
NeoBundle 'editorconfig/editorconfig-vim', {
      \   'depends': 'vim-scripts/PreserveNoEOL',
      \   'disabled': !(has("python") || has("python3")),
      \ }

" highlight matching html tag
NeoBundleLazy 'gregsexton/MatchTag', {
      \   'autoload': { 'filetypes': ['html', 'mustache', 'php', 'rb'] }
      \ }

NeoBundle 'scrooloose/syntastic'
if neobundle#tap('syntastic')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:syntastic_aggregate_errors         = 1
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list            = 1
    let g:syntastic_check_on_open            = 1
    let g:syntastic_check_on_wq              = 1
    let g:syntastic_enable_signs             = 1
    let g:syntastic_enable_highlighting      = 1

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
      let g:syntastic_mode_map['passive_filetypes'] = [ 'html', 'php' ]
    endif

    let g:syntastic_error_symbol         = '✗'
    let g:syntastic_style_error_symbol   = '✠'
    let g:syntastic_warning_symbol       = '∆'
    let g:syntastic_style_warning_symbol = '≈'

    " ignore angular attrs
    let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

    let g:syntastic_coffeescript_checkers = ['coffee', 'coffeelint']
    let g:syntastic_php_checkers = ['php', 'phpmd']
    let g:syntastic_shell_checkers = ['bashate', 'shellcheck']
  endfunction
  call neobundle#untap()
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language specific
"
" Chef """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundleLazy 'vadv/vim-chef', {'autoload': {'filetypes': ['ruby', 'eruby']}}

" CoffeeScript """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'kchmck/vim-coffee-script'  " creates coffee ft

" tagbar ctags for coffee
NeoBundle 'lukaszkorecki/CoffeeTags', {
      \   'disabled': !executable("coffeetags"),
      \ }
if neobundle#tap('vim-coffee-script')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:coffee_compile_vert = 1
    let g:coffee_watch_vert = 1
  endfunction
  call neobundle#untap()
endif

" ColdFusion """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundleLazy 'alampros/cf.vim', {
      \   'autoload': { 'filetypes': [ 'cfml' ] }
      \ }
NeoBundle 'davejlong/cf-utils.vim'      " creates cfml filetype

" Git """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-git'               " creates gitconfig, gitcommit, rebase

" HTML and generators """"""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'digitaltoad/vim-jade'        " creates jade filetype
NeoBundle 'tpope/vim-haml'              " creates haml, sass, scss filetypes

" JavaScript """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'itspriddle/vim-jquery'         " creates javascript syntax
NeoBundle 'jelera/vim-javascript-syntax'  " also creates javascript syntax

NeoBundle 'marijnh/tern_for_vim'          " autocomplete/typehints engine, also
                                          " used by tagbar

NeoBundle 'othree/javascript-libraries-syntax.vim'
if neobundle#tap('javascript-libraries-syntax.vim')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:used_javascript_libs = 'jquery,underscore,backbone'
  endfunction
  call neobundle#untap()
endif

NeoBundle 'pangloss/vim-javascript'     " also creates javascript filetype
if neobundle#tap('vim-javascript')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:javascript_enable_domhtmlcss=1
  endfunction
  call neobundle#untap()
endif

NeoBundle 'heavenshell/vim-jsdoc'
if neobundle#tap('vim-jsdoc')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:jsdoc_default_mapping = 0
    if has("autocmd")
      au FileType javascript nnoremap <Leader>pd :JsDoc<CR>
      au FileType javascript vnoremap <Leader>pd :JsDoc<CR>
    endif
  endfunction
  call neobundle#untap()
endif

" JSON """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'elzr/vim-json'               " creates json filetype
if neobundle#tap('vim-json')
  function! neobundle#tapped.hooks.on_source(bundle)
    if has("autocmd")
      " JSON force JSON not javascript
      au BufRead,BufNewFile *.json setlocal filetype=json
    endif
  endfunction
  call neobundle#untap()
endif

" Markdown """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'tpope/vim-markdown'          " creates markdown filetype
NeoBundle 'jtratner/vim-flavored-markdown', {
      \   'depends': 'tpope/vim-markdown'
      \ }
if neobundle#tap('vim-json')
  function! neobundle#tapped.hooks.on_source(bundle)
    if has("autocmd")
      augroup markdown
          " remove other autocmds for markdown first
          au!
          au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
      augroup END
    endif
  endfunction
  call neobundle#untap()
endif

" Mustache.js and Handlebars """""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'mustache/vim-mustache-handlebars' " creates mustache filetype

" PHP """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundleLazy 'tobyS/pdv', {
      \   'depends': 'tobyS/vmustache',
      \   'autoload': { 'filetypes': ['php', 'blade'] }
      \ }
if neobundle#tap('pdv')
  function! neobundle#tapped.hooks.on_source(bundle)
    let g:pdv_template_dir = expand("~/.vim/bundle/pdv/templates")
    if has("autocmd")
      au FileType php nnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>
      au FileType php vnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>
    endif
  endfunction
  call neobundle#untap()
endif

NeoBundleLazy 'shawncplus/phpcomplete.vim', {
      \   'autoload': { 'filetypes': ['php', 'blade'] }
      \ }
if neobundle#tap('phpcomplete.vim')
  function! neobundle#tapped.hooks.on_source(bundle)
    " mapping conflict with vim-rails, change <C-]> to <C-)>
    let g:phpcomplete_enhance_jump_to_definition=0
    if !hasmapto('<Plug>PHPJump')
      map! <silent> <buffer> <unique> <C-)> <Plug>PHPJump
      map! <silent> <buffer> <unique> <C-W><C-)> <Plug>PHPJumpW
    endif
    nnoremap <silent> <buffer> <Plug>PHPJump :<C-u>call phpcomplete#JumpToDefinition('normal')<CR>
    nnoremap <silent> <buffer> <Plug>PHPJumpW :<C-u>call phpcomplete#JumpToDefinition('split')<CR>
  endfunction
  call neobundle#untap()
endif

NeoBundle 'StanAngeloff/php.vim'        " updated syntax

"NeoBundleLazy 'dsawardekar/wordpress.vim', {
      "\   'depends': [
      "\     'kien/ctrlp.vim',
      "\     'shawncplus/phpcomplete.vim',
      "\   ],
      "\   'autoload': { 'filetypes': ['php'] }
      "\ }

NeoBundleLazy 'vim-php/tagbar-phpctags.vim', {
      \   'autoload': { 'filetypes': ['php', 'blade'] },
      \   'build': {
      \     'mac': 'make',
      \     'unix': 'make',
      \    },
      \   'depends' : 'majutsushi/tagbar',
      \   'disabled': !executable("ctags"),
      \ }

" Puppet """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'rodjek/vim-puppet'           " creates pp filetype

" Ruby, rails """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundleLazy 'tpope/vim-rails', {'autoload': {'filetypes': [ 'ruby' ]}}
NeoBundle 'vim-ruby/vim-ruby'           " creates ruby filetype

" Stylesheet languages """""""""""""""""""""""""""""""""""""""""""""""""""""""""

NeoBundleLazy 'ap/vim-css-color', {
      \   'autoload': {
      \     'filetypes': [ 'php', 'html', 'css', 'less', 'scss', 'sass', 'javascript', 'coffee' ]
      \   }
      \ }

NeoBundle 'cakebaker/scss-syntax.vim'   " creates scss.css
NeoBundle 'groenewege/vim-less'         " creates less filetype
NeoBundleLazy 'hail2u/vim-css3-syntax', { 'autoload': { 'filetypes': ['css', 'sass', 'scss'] } }

" Twig """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'evidens/vim-twig'            " creates twig

" VimL """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'syngan/vim-vimlint', {
      \   'depends' : 'ynkdir/vim-vimlparser'
      \ }

NeoBundle 'ynkdir/vim-vimlparser'

" YAML """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
NeoBundle 'ingydotnet/yaml-vim'


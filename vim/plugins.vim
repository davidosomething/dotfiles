""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin dependencies
NeoBundle 'kana/vim-operator-user', {
      \   'autoload' : {
      \     'functions' : 'operator#user#define'
      \   }
      \ }
NeoBundle 'MarcWeber/vim-addon-mw-utils'
NeoBundle 'rizzatti/funcoo.vim'
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ui
NeoBundle 'altercation/vim-colors-solarized'
  if neobundle#tap('vim-colors-solarized')
    silent! colorscheme solarized               " STFU if no solarized
  endif
NeoBundle 'dockyard/vim-easydir'
NeoBundle 'itchyny/lightline.vim'
  let g:lightline = {
        \   'depends': 'rizzatti/funcoo.vim',
        \   'active': {
        \     'left': [
        \         [ 'mode', 'paste' ],
        \         [ 'fugitive', 'readonly', 'filename', 'modified' ]
        \     ]
        \   },
        \   'component': {
        \     'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
        \     'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
        \     'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
        \   },
        \   'component_visible_condition': {
        \     'readonly': '(&filetype!="help"&& &readonly)',
        \     'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
        \     'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
        \   },
        \ }
NeoBundle 'kien/tabman.vim'
  nnoremap <F2> :TMToggle<CR>
NeoBundle 'kien/ctrlp.vim'
  let g:ctrlp_map = '<c-t>'
NeoBundle 'mhinz/vim-hugefile'
NeoBundle 'nathanaelkane/vim-indent-guides'
  nnoremap <F7> :IndentGuidesToggle<CR>

" used by lightline
NeoBundleLazy 'tpope/vim-fugitive', {
        \   'augroup': 'fugitive'
        \ }

NeoBundle 'vim-scripts/IndexedSearch'
NeoBundle 'vim-scripts/kwbdi.vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" menus and special features
if g:is_macvim
  NeoBundle 'henrik/vim-reveal-in-finder'
endif
NeoBundle 'jeetsukumaran/vim-buffergator'
  nnoremap <F3> :BuffergatorToggle<CR>
if executable("ctags")
  NeoBundle 'majutsushi/tagbar', {
        \   'autoload': {
        \     'commands': [ 'Tagbar', 'TagbarClose', 'TagbarOpen', 'TagbarToggle' ]
        \   }
        \ }
    let g:tagbar_show_linenumbers = 1     " Show absolute line numbers
    nnoremap <F4> :TagbarToggle<CR>
endif
NeoBundleLazy 'scrooloose/nerdtree', {
      \   'augroup': 'NERDTreeHijackNetrw',
      \   'autoload': {
      \     'commands': [ 'NERDTreeFind', 'NERDTreeToggle', 'NERDTree' ]
      \   }
      \ }

  let NERDTreeShowHidden = 1
  let NERDTreeHijackNetrw = 1
  let NERDTreeMinimalUI=1
  nnoremap <F1> :NERDTreeToggle %<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocomplete
NeoBundle 'honza/vim-snippets'
if g:settings.autocomplete_method == 'ycm'
  NeoBundle 'Valloric/YouCompleteMe', {
        \   'vim_version':'7.3.584',
        \   'build' : {
        \     'mac' : './install.sh --clang-completer --system-libclang',
        \     'unix' : './install.sh --clang-completer --system-libclang'
        \   }
        \ }
    let g:ycm_complete_in_comments_and_strings=1
"  NeoBundle 'SirVer/ultisnips'
    "let g:UltiSnipsExpandTrigger="<tab>"
    "let g:UltiSnipsJumpForwardTrigger="<tab>"
    "let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"    let g:UltiSnipsSnippetsDir='~/.vim/ultisnips'
else
  NeoBundle 'Shougo/neosnippet-snippets', {
        \   'depends': 'Shougo/neosnippet.vim'
        \ }
    let g:neosnippet#enable_snipmate_compatibility=1

    " load honza vim-snippets and personal snippets from .vim/snippets
    let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets,~/.vim/snippets'

    imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
          \ "\<Plug>(neosnippet_expand_or_jump)"
          \ : (pumvisible() ? "\<C-n>" : "\<TAB>")
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
          \ "\<Plug>(neosnippet_expand_or_jump)"
          \ : "\<TAB>"
    imap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
    smap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
endif
if g:settings.autocomplete_method == 'neocomplete'
  NeoBundle 'Shougo/neocomplete.vim', {
        \   'vim_version':'7.3.885'
        \ }
    let g:neocomplete#enable_at_startup=1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#data_directory='~/.vim/.cache/neocomplete'
  NeoBundle 'Shougo/neosnippet.vim', {
        \   'depends': 'Shougo/neocomplete.vim'
        \ }
endif
if g:settings.autocomplete_method == 'neocomplcache'
  NeoBundle 'Shougo/neocomplcache.vim'
    let g:neocomplcache_enable_at_startup=1
    let g:neocomplcache_enable_smart_case            = 1
    let g:neocomplcache_enable_camel_case_completion = 1
    let g:neocomplcache_enable_underbar_completion   = 1
    let g:neocomplcache_enable_fuzzy_completion=1
    let g:neocomplcache_temporary_dir='~/.vim/.cache/neocomplcache'
    " default # of completions is 100, that's crazy
    let g:neocomplcache_max_list = 10
    " words less than 3 letters long aren't worth completing
    let g:neocomplcache_min_syntax_length = 3
    " start filling in after 2 chars
    let g:neocomplcache_auto_completion_start_length = 2
    " This makes sure we use neocomplcache completefunc instead of
    " the one in rails.vim, otherwise this plugin will crap out
    let g:neocomplcache_force_overwrite_completefunc = 1
    " Enable heavy omni completion.
    if !exists('g:neocomplcache_omni_patterns')
      let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
  NeoBundle 'Shougo/neosnippet.vim', {
        \   'depends': 'Shougo/neocomplcache.vim'
        \ }
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" commands
NeoBundle 'osyo-manga/vim-over'
if has("gui_macvim")
  NeoBundle 'rizzatti/dash.vim', {
        \   'depends': 'rizzatti/funcoo.vim'
        \ }
endif
NeoBundle 'Keithbsmiley/investigate.vim'
  let g:investigate_use_dash=1
NeoBundle 'mileszs/ack.vim'
NeoBundle 'rking/ag.vim'
NeoBundle 'tpope/vim-eunuch'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" editing keys
NeoBundle 'edsono/vim-matchit'
NeoBundle 'ervandew/supertab'
  let g:SuperTabDefaultCompletionType = "context"
  let g:SuperTabContextDefaultCompletionType = "<c-n>"
NeoBundle 'godlygeek/tabular', {'autoload':{'commands':'Tabularize'}}
  nmap <Leader>a- :Tabularize /-<CR>
  vmap <Leader>a- :Tabularize /-<CR>
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
  nmap <Leader>a, :Tabularize /,<CR>
  vmap <Leader>a, :Tabularize /,<CR>
  nmap <Leader>af :Tabularize /=>/<CR>
  vmap <Leader>af :Tabularize /=>/<CR>
NeoBundleLazy 'jaxbot/github-issues.vim'
NeoBundle 'maxbrunsfeld/vim-yankstack'
  let g:yankstack_map_keys = 0
  nmap <C-p> <Plug>yankstack_substitute_newer_paste
  nmap <C-P> <Plug>yankstack_substitute_older_paste
NeoBundle 'nishigori/increment-activator'           " custom C-x C-a mappings
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-repeat', {
      \   'autoload': { 'mappings': '.' }
      \ }
NeoBundle 'tpope/vim-speeddating'       " fast increment datetimes
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'        " keyb shortcut for next quickfix, file
NeoBundle 'tyru/operator-camelize.vim', {
      \   'depends': 'vim-operator-user',
      \   'autoload': {
      \     'mappings': [
      \       [ '<Plug>(operator-camelize-)' ]
      \     ]
      \   }
      \ }
      nmap <c-c> <Plug>(operator-camelize-toggle)
NeoBundle 'kana/vim-operator-replace', {
      \   'depends': 'vim-operator-user',
      \   'autoload': {
      \     'mappings': [
      \       [ 'nx', '<Plug>(operator-replace)' ],
      \     ],
      \   }
      \ }
      map _ <Plug>(operator-replace)
NeoBundle 'vim-scripts/AnsiEsc.vim'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" text objects
NeoBundle 'kana/vim-textobj-indent', {
      \   'depends': 'vim-textobj-user',
      \ }
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'lucapette/vim-textobj-underscore', {
      \   'depends': 'vim-textobj-user',
      \ }
NeoBundle 'paradigm/TextObjectify'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntax highlighting
if has("python")
  NeoBundle 'editorconfig/editorconfig-vim'
  let g:EditorConfig_core_mode = 'python_builtin'
  let g:EditorConfig_python_files_dir = $DOTFILES . "/vim/bundle/editorconfig-vim/plugin/editorconfig-core-py"
endif
NeoBundleLazy 'gregsexton/MatchTag'
NeoBundle 'scrooloose/syntastic'
  " run syntastic on file open
  let g:syntastic_check_on_open       = 1
  let g:syntastic_auto_loc_list       = 1
  let g:syntastic_enable_signs        = 1
  let g:syntastic_enable_highlighting = 1
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
    let g:syntastic_mode_map['passive_filetypes'] = ['python', 'html']
  endif
  let g:syntastic_error_symbol = '✗'
  let g:syntastic_style_error_symbol = '✠'
  let g:syntastic_warning_symbol = '∆'
  let g:syntastic_style_warning_symbol = '≈'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language specific

""""""""""""""""""""""""""""""""""""""""
" Chef
NeoBundleLazy 'vadv/vim-chef', {'autoload': {'filetypes': ['ruby', 'eruby']}}

""""""""""""""""""""""""""""""""""""""""
" ColdFusion
NeoBundleLazy 'alampros/cf.vim', {
      \   'autoload': { 'filetypes': [ 'cfml' ] }
      \ }
NeoBundle 'davejlong/cf-utils.vim' " creates cfml filetype

""""""""""""""""""""""""""""""""""""""""
" HTML and generators
NeoBundleLazy 'digitaltoad/vim-jade'    " creates jade filetype
"NeoBundle 'mattn/emmet-vim'
NeoBundle 'tpope/vim-haml'              " creates haml, sass, scss filetypes

""""""""""""""""""""""""""""""""""""""""
" JavaScript
NeoBundle 'itspriddle/vim-jquery'       " creates javascript syntax
NeoBundle 'jelera/vim-javascript-syntax' " also creates javascript syntax
NeoBundleLazy 'othree/javascript-libraries-syntax.vim', { 'autoload': { 'filetypes': ['javascript'] } }
NeoBundle 'pangloss/vim-javascript'     " also creates javascript filetype

""""""""""""""""""""""""""""""""""""""""
" JSON
NeoBundle 'elzr/vim-json'               " creates json filetype
  if has("autocmd") && neobundle#tap('vim-json')
    " JSON force JSON not javascript
    au BufRead,BufNewFile *.json setlocal filetype=json
  endif

""""""""""""""""""""""""""""""""""""""""
" Markdown
NeoBundle 'tpope/vim-markdown'          " creates markdown filetype

""""""""""""""""""""""""""""""""""""""""
" Mustache.js and Handlebars
NeoBundleLazy 'mustache/vim-mustache-handlebars' " creates mustache filetype
  if neobundle#tap('vim-mustache-handlebars')
    " HBS is a handlebars file
    au BufRead,BufNewFile *.hbs setlocal filetype=mustache
  endif
"NeoBundleLazy 'juvenn/mustache.vim', { 'autoload': { 'filetypes': ['handlebars', 'hbs', 'mustache'] } }

""""""""""""""""""""""""""""""""""""""""
" PHP
NeoBundleLazy 'tobyS/pdv', {
      \   'depends': 'tobyS/vmustache',
      \   'autoload': { 'filetypes': ['php', 'blade'] }
      \ }
  let g:pdv_template_dir = $HOME . "/.vim/bundle/pdv/templates"
  if has("autocmd")
    au FileType php nnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>
    au FileType php vnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>
  endif
NeoBundleLazy 'shawncplus/phpcomplete.vim', {
      \   'autoload': { 'filetypes': ['php', 'blade'] }
      \ }
NeoBundle 'StanAngeloff/php.vim'        " updated syntax

"      \     'SirVer/ultisnips'
NeoBundleLazy 'dsawardekar/wordpress.vim', {
      \   'depends': [
      \     'kien/ctrlp.vim',
      \     'shawncplus/phpcomplete.vim',
      \   ],
      \   'autoload': { 'filetypes': ['php'] }
      \ }

NeoBundleLazy 'vim-php/tagbar-phpctags.vim', {
      \   'autoload': { 'filetypes': ['php', 'blade'] },
      \   'build': {
      \     'mac': 'make',
      \     'unix': 'make',
      \    },
      \ }

""""""""""""""""""""""""""""""""""""""""
" Puppet
NeoBundle 'rodjek/vim-puppet'           " creates pp filetype

""""""""""""""""""""""""""""""""""""""""
" Ruby, rails
NeoBundleLazy 'tpope/vim-rails', {'autoload': {'filetypes': [ 'ruby' ]}}
NeoBundle 'vim-ruby/vim-ruby'           " creates ruby filetype

""""""""""""""""""""""""""""""""""""""""
" Stylesheet languages
NeoBundleLazy 'gorodinskiy/vim-coloresque'
"NeoBundleLazy 'ap/vim-css-color', {
"      \   'autoload': {
"      \     'filetypes': [ 'php', 'html', 'css', 'less', 'scss', 'sass', 'javascript', 'coffee', 'coffeescript' ]
"      \   }
"      \ }
"NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'groenewege/vim-less'         " creates less filetype
NeoBundleLazy 'hail2u/vim-css3-syntax', { 'autoload': { 'filetypes': ['css', 'sass', 'scss'] } }

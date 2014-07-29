scriptencoding UTF-8

" Don't need:
" - jeetsukumaran/vim-buffergator - CtrlP has a buffer mode
" - kien/tabman.vim - CtrlP does the same thing
" - matthias-guenther/hammer.vim - rbenv shell sys didn't work to install
" - scrooloose/nerdtree - go full on CtrlP
" - shougo/neosnippet.vim - use UltiSnips for WordPress.vim integration
" - shougo/unite.vim - CtrlP has WordPress.vim integration
" - vim-command-w - doesn't work
" - vim-scripts/kwbdi.vim - Bufkill is newer, maybe use vim-command-w?
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin dependencies

" editorconfig-vim uses this
NeoBundle 'vim-scripts/PreserveNoEOL'

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

NeoBundle 'ynkdir/vim-vimlparser'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ui
NeoBundle 'altercation/vim-colors-solarized'
  if neobundle#tap('vim-colors-solarized')
    silent! colorscheme solarized               " STFU if no solarized
    silent! call togglebg#map("<F5>")
  endif

NeoBundle 'dockyard/vim-easydir'        " creates dir if new file in new dir

NeoBundle 'itchyny/lightline.vim', {
      \   'depends': 'vim-fugitive'
      \ }
  let g:lightline = {
        \   'active': {
        \     'left': [
        \         [ 'mode', 'paste' ],
        \         [ 'fugitive', 'readonly', 'filename', 'modified' ]
        \     ]
        \   },
        \   'component': {
        \     'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
        \     'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
        \   },
        \   'component_visible_condition': {
        \     'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
        \     'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
        \   },
        \   'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
        \   'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
        \ }

NeoBundle 'tacahiroy/ctrlp-funky'
  nnoremap <F8> :CtrlPFunky<Cr>

NeoBundle 'kien/ctrlp.vim'
  let g:ctrlp_extensions = ['funky']
  let g:ctrlp_map = '<F1>'
  let g:ctrlp_match_window = 'order:ttb,min:10'
  let g:ctrlp_max_depth = 16
  let g:ctrlp_mru_files = 1             " Enable MRU
  let g:ctrlp_jump_to_buffer = 2        " Jump to tab AND buffer if already open
  let g:ctrlp_split_window = 1          " <CR> = New Tab
  " The Silver Searcher
  if executable('ag')
    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
  endif
  inoremap <F2> <Esc>:CtrlPBuffer<CR>
  nnoremap <F2> :CtrlPBuffer<CR>
  inoremap <F3> <Esc>:CtrlPMixed<CR>
  nnoremap <F3> :CtrlPMixed<CR>

NeoBundle 'mhinz/vim-hugefile'          " disable vim features for large files

NeoBundle 'nathanaelkane/vim-indent-guides'
  nnoremap <F7> :IndentGuidesToggle<CR>

NeoBundle 'tpope/vim-fugitive'

NeoBundle 'vim-scripts/bufkill.vim'     " :bd keeps window open

NeoBundle 'vim-scripts/IndexedSearch'

if executable("ctags")
  NeoBundle 'majutsushi/tagbar'
    let g:tagbar_compact = 1
    let g:tagbar_show_linenumbers = 1     " Show absolute line numbers
    nnoremap <F4> :TagbarToggle<CR>
endif

NeoBundle 'osyo-manga/vim-over'
  nnoremap <c-s> :OverCommandLine<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" commands
if g:is_macvim
  NeoBundle 'henrik/vim-reveal-in-finder'
endif

NeoBundle 'Keithbsmiley/investigate.vim'
nnoremap <leader>K :call investigate#Investigate()<CR>
if g:is_macvim
  let g:investigate_use_dash=1
endif

NeoBundle 'mileszs/ack.vim'

NeoBundle 'mrtazz/simplenote.vim'
  let g:SimplenoteVertical=1
  if filereadable(expand("~/.simplenoterc"))
    source ~/.simplenoterc
  endif

NeoBundle 'rking/ag.vim'

NeoBundle 'tpope/vim-eunuch'

NeoBundle 'tpope/vim-unimpaired'        " used for line bubbling commands on osx

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" autocomplete
if g:settings.autocomplete_method == 'neocomplete'
  NeoBundle 'Shougo/neocomplete.vim', {
        \   'vim_version':'7.3.885'
        \ }

    let g:acp_enableAtStartup = 0
    let g:neocomplete#enable_at_startup            = 1
    let g:neocomplete#enable_smart_case            = 1
    let g:neocomplete#enable_camel_case_completion = 1
    let g:neocomplete#enable_underbar_completion   = 1
    let g:neocomplete#enable_fuzzy_completion      = 1
    let g:neocomplete#force_overwrite_completefunc = 1
    let g:neocomplete#data_directory = '~/.vim/.cache/neocomplete'

    " from the github page: <CR> cancels completion and inserts newline
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return neocomplete#close_popup() . "\<CR>"
    endfunction

endif
if g:settings.autocomplete_method == 'neocomplcache'
  NeoBundle 'Shougo/neocomplcache.vim'
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
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" editing keys
NeoBundle 'edsono/vim-matchit'

NeoBundle 'ervandew/supertab'
  let g:SuperTabDefaultCompletionType = "context"
  let g:SuperTabContextDefaultCompletionType = "<c-n>"

NeoBundle 'godlygeek/tabular', {'autoload':{'commands':'Tabularize'}}
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

NeoBundle 'svermeulen/vim-easyclip'

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
    let g:syntastic_mode_map['passive_filetypes'] = [ 'html' ]
  endif
  let g:syntastic_error_symbol         = '✗'
  let g:syntastic_style_error_symbol   = '✠'
  let g:syntastic_warning_symbol       = '∆'
  let g:syntastic_style_warning_symbol = '≈'

  " ignore angular attrs
  let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

  " Navigate errors
  nnoremap <silent> <S-Up> :lprev<CR>
  nnoremap <silent> <S-Down> :lnext<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language specific
"
""""""""""""""""""""""""""""""""""""""""
" Chef
NeoBundleLazy 'vadv/vim-chef', {'autoload': {'filetypes': ['ruby', 'eruby']}}

""""""""""""""""""""""""""""""""""""""""
" CoffeeScript
NeoBundle 'kchmck/vim-coffee-script' " creates coffee ft
  let g:coffee_compile_vert = 1
  let g:coffee_watch_vert = 1

""""""""""""""""""""""""""""""""""""""""
" ColdFusion
NeoBundleLazy 'alampros/cf.vim', {
      \   'autoload': { 'filetypes': [ 'cfml' ] }
      \ }
NeoBundle 'davejlong/cf-utils.vim'      " creates cfml filetype

""""""""""""""""""""""""""""""""""""""""
" Git
NeoBundle 'tpope/vim-git'               " creates gitconfig, gitcommit, rebase

""""""""""""""""""""""""""""""""""""""""
" HTML and generators
NeoBundle 'digitaltoad/vim-jade'        " creates jade filetype
NeoBundle 'tpope/vim-haml'              " creates haml, sass, scss filetypes

""""""""""""""""""""""""""""""""""""""""
" JavaScript
NeoBundle 'itspriddle/vim-jquery'       " creates javascript syntax
NeoBundle 'jelera/vim-javascript-syntax' " also creates javascript syntax

NeoBundle 'othree/javascript-libraries-syntax.vim'
  let g:used_javascript_libs = 'jquery,underscore,backbone'

NeoBundle 'pangloss/vim-javascript'     " also creates javascript filetype
NeoBundle 'heavenshell/vim-jsdoc'
  let g:jsdoc_default_mapping = 0
  if has("autocmd")
    au FileType javascript nnoremap <Leader>pd :JsDoc<CR>
    au FileType javascript vnoremap <Leader>pd :JsDoc<CR>
  endif

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
NeoBundle 'jtratner/vim-flavored-markdown', {
      \   'depends': 'tpope/vim-markdown'
      \ }
  if has("autocmd")
    augroup markdown
        " remove other autocmds for markdown first
        au!
        au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
    augroup END
  endif

""""""""""""""""""""""""""""""""""""""""
" Mustache.js and Handlebars
NeoBundle 'mustache/vim-mustache-handlebars' " creates mustache filetype

""""""""""""""""""""""""""""""""""""""""
" PHP
NeoBundleLazy 'tobyS/pdv', {
      \   'depends': 'tobyS/vmustache',
      \   'autoload': { 'filetypes': ['php', 'blade'] }
      \ }
  let g:pdv_template_dir = expand("~/.vim/bundle/pdv/templates")
  if has("autocmd")
    au FileType php nnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>
    au FileType php vnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>
  endif
NeoBundleLazy 'shawncplus/phpcomplete.vim', {
      \   'autoload': { 'filetypes': ['php', 'blade'] }
      \ }
NeoBundle 'StanAngeloff/php.vim'        " updated syntax

"NeoBundleLazy 'dsawardekar/wordpress.vim', {
      "\   'depends': [
      "\     'kien/ctrlp.vim',
      "\     'shawncplus/phpcomplete.vim',
      "\   ],
      "\   'autoload': { 'filetypes': ['php'] }
      "\ }

if executable("ctags")
  NeoBundleLazy 'vim-php/tagbar-phpctags.vim', {
        \   'autoload': { 'filetypes': ['php', 'blade'] },
        \   'build': {
        \     'mac': 'make',
        \     'unix': 'make',
        \    },
        \ }
endif

""""""""""""""""""""""""""""""""""""""""
" Puppet
NeoBundle 'rodjek/vim-puppet'           " creates pp filetype

""""""""""""""""""""""""""""""""""""""""
" Ruby, rails
NeoBundleLazy 'tpope/vim-rails', {'autoload': {'filetypes': [ 'ruby' ]}}
NeoBundle 'vim-ruby/vim-ruby'           " creates ruby filetype

""""""""""""""""""""""""""""""""""""""""
" Stylesheet languages
" Not sure what color plugin to use yet
"NeoBundleLazy 'gorodinskiy/vim-coloresque', {
NeoBundleLazy 'ap/vim-css-color', {
      \   'autoload': {
      \     'filetypes': [ 'php', 'html', 'css', 'less', 'scss', 'sass', 'javascript', 'coffee' ]
      \   }
      \ }
NeoBundle 'cakebaker/scss-syntax.vim'   " creates scss.css
NeoBundle 'groenewege/vim-less'         " creates less filetype
NeoBundleLazy 'hail2u/vim-css3-syntax', { 'autoload': { 'filetypes': ['css', 'sass', 'scss'] } }

""""""""""""""""""""""""""""""""""""""""
" Twig
NeoBundle 'evidens/vim-twig'            " creates twig

""""""""""""""""""""""""""""""""""""""""
" VimL
NeoBundle 'syngan/vim-vimlint', {
      \   'depends' : 'ynkdir/vim-vimlparser'
      \ }

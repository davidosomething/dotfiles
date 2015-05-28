let g:neobundle#log_filename = expand('$DOTFILES/logs/neobundle.log')

" Ensure neobundle exists
let g:is_first_neobundle = 0
if empty(glob('~/.vim/bundle/neobundle.vim'))
  silent !curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
  autocmd vimrc VimEnter * NeoBundleUpdate
  let g:is_first_neobundle = 1
endif

if has("vim_starting")
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('$VIM_DOTFILES/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

" plugin dependencies ----------------------------------------------------------
NeoBundle 'Shougo/vimproc', {
      \   'build': {
      \     'mac':     'make -f make_mac.mak',
      \     'unix':    'make -f make_unix.mak',
      \     'cygwin':  'make -f make_cygwin.mak',
      \     'windows': 'make -f make_mingw32.mak',
      \   },
      \ }

if g:is_first_neobundle
  NeoBundleInstall 'vimproc'
endif

NeoBundle 'tobyS/vmustache' " for pdv

" ui ---------------------------------------------------------------------------
NeoBundle 'altercation/vim-colors-solarized', { 'gui': 1 }
if neobundle#tap('vim-colors-solarized')
  " turn off gross italics -- fira sans happens to use ligatures too
  let g:solarized_italic = 0

  function! neobundle#hooks.on_source(bundle)
    set background=light
    silent! colorscheme solarized               " STFU if no solarized
    silent! call togglebg#map("<F5>")
  endfunction
  call neobundle#untap()
endif

NeoBundle 'bling/vim-airline'
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

" show registers in tem split if use \" or <C-R>
NeoBundle 'junegunn/vim-peekaboo'

" auto tag generation via exuberant-ctags -- no tags file created
NeoBundleLazy 'majutsushi/tagbar', {
      \   'autoload': { 'commands': 'TagbarToggle' },
      \   'disabled': !executable("ctags"),
      \ }
if neobundle#tap('tagbar')
  nmap <silent><F10> :TagbarToggle<CR>
  imap <silent><F10> <Esc>:TagbarToggle<CR>
  vmap <silent><F10> <Esc>:TagbarToggle<CR>

  let g:tagbar_autoclose = 1            " close after jumping
  let g:tagbar_autofocus = 1
  let g:tagbar_compact = 1
  let g:tagbar_show_linenumbers = 1     " Show absolute line numbers
  call neobundle#untap()
endif

NeoBundle 'mhinz/vim-hugefile'          " disable vim features for large files

NeoBundle 'nathanaelkane/vim-indent-guides'
if neobundle#tap('vim-indent-guides')
  let g:indent_guides_color_change_percent = 2

  nmap <silent><F6> <Plug>IndentGuidesToggle
  inoremap <silent><F6> <Esc>:IndentGuidesToggle<CR>a
  call neobundle#untap()
endif

NeoBundle 'now/vim-quit-if-only-quickfix-buffer-left'

" Most recently used files for unite.vim -- config is in unite.vim
NeoBundle 'Shougo/neomru.vim'

NeoBundle 'Shougo/unite.vim', {
      \   'depends': [ 'Shougo/vimproc', 'Shougo/neomru.vim' ],
      \ }
if neobundle#tap('unite.vim')

  " track yanks
  let g:unite_source_history_yank_enable = 1

  " candidates
  let g:unite_source_grep_max_candidates = 300

  " use ag for file_rec/async and unite grep
  if executable('ag')
    let s:ag_opts =
          \ ' --vimgrep'
          " \ ' --nocolor --nogroup --numbers' .
          " \ ' --follow --smart-case --hidden'

    " Ignore wildignores too
    " https://github.com/gf3/dotfiles/blob/master/.vimrc#L564
    for i in split(&wildignore, ",")
      let i = substitute(i, '\*/\(.*\)/\*', '\1', 'g')
      let s:ag_opts = s:ag_opts .
            \ ' --ignore "' . substitute(i, '\*/\(.*\)/\*', '\1', 'g') . '"'
    endfor

    let g:unite_source_rec_async_command = 'ag' .
          \ s:ag_opts .
          \ ' -g ""'

    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = s:ag_opts
    let g:unite_source_grep_recursive_opt = ''
  endif

  function! neobundle#hooks.on_source(bundle)
    " ========================================
    " open in bottom pane like ctrl-p
    call unite#custom#profile('default', 'context', {
          \   'direction':          'botright',
          \   'max_candidates':     300,
          \   'short_source_names': 1,
          \   'silent':             1,
          \   'winheight':          12,
          \ })

    " ========================================
    " always use fuzzy match (e.g. type abc to match app/book/collection)
    call unite#filters#matcher_default#use(
          \   ['matcher_project_files', 'matcher_fuzzy']
          \ )

    " ========================================
    " display relative paths in file search
    " using stock filter
    " https://github.com/Shougo/unite.vim/blob/master/autoload/unite/filters/converter_relative_word.vim
    call unite#custom#source(
          \   'file_rec,file_rec/async,neomru/file', 'converters',
          \   ['converter_relative_word']
          \ )

    " ========================================
    " Unite buffer keybindings
    function! s:unite_my_settings()
      " never go to unite normal mode
      " for unite buffers, exit immediately on <Esc>
      " " https://github.com/Shougo/unite.vim/issues/693#issuecomment-67889305
      imap <buffer> <Esc>          <Plug>(unite_exit)
      nmap <buffer> <Esc>          <Plug>(unite_exit)

      " also exit on unite-bound function keys, so you can toggle open and
      " close with same key
      imap <buffer> <F1>           <Plug>(unite_exit)
      nmap <buffer> <F1>           <Plug>(unite_exit)
      imap <buffer> <F2>           <Plug>(unite_exit)
      nmap <buffer> <F2>           <Plug>(unite_exit)
      imap <buffer> <F3>           <Plug>(unite_exit)
      nmap <buffer> <F3>           <Plug>(unite_exit)
      imap <buffer> <F11>          <Plug>(unite_exit)
      nmap <buffer> <F11>          <Plug>(unite_exit)

      " never use unite actions on TAB
      iunmap <buffer> <Tab>
      nunmap <buffer> <Tab>
    endfunction
    autocmd vimrc FileType unite call s:unite_my_settings()

    " ========================================
    " command-t/ctrlp replacement
    nnoremap <silent><F1> :<C-u>Unite -start-insert file_rec/async:!<CR>
    inoremap <silent><F1> <Esc>:<C-u>Unite -start-insert file_rec/async:!<CR>
    vnoremap <silent><F1> <Esc>:<C-u>Unite -start-insert file_rec/async:!<CR>

    " ========================================
    " recently used
    nnoremap <silent><F2> :<C-u>Unite -start-insert neomru/file<CR>
    inoremap <silent><F2> <Esc>:<C-u>Unite -start-insert neomru/file<CR>
    vnoremap <silent><F2> <Esc>:<C-u>Unite -start-insert neomru/file<CR>

    " ========================================
    " find in files (ag.vim/ack.vim replacement)
    nnoremap <silent><F3> :<C-u>Unite grep:.<CR>
    inoremap <silent><F3> <Esc>:<C-u>Unite grep:.<CR>
    vnoremap <silent><F3> <Esc>:<C-u>Unite grep:.<CR>

    " ========================================
    " find in yank history
    nnoremap <silent><F11> :<C-u>Unite history/yank<CR>
    inoremap <silent><F11> <Esc>:<C-u>Unite history/yank<CR>
    vnoremap <silent><F11> <Esc>:<C-u>Unite history/yank<CR>

    " ========================================
    " Command Palette
    nnoremap <C-y> :<C-u>Unite -start-insert command<CR>
    inoremap <C-y> <Esc>:<C-u>Unite -start-insert command<CR>
    vnoremap <C-y> <Esc>:<C-u>Unite -start-insert command<CR>

  endfunction
  call neobundle#untap()
endif

" Don't lazy vimfiler so it can handler opening dirs from terminal
NeoBundle 'Shougo/vimfiler.vim', {
      \   'depends': 'Shougo/unite.vim',
      \ }
if neobundle#tap('vimfiler.vim')
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_tree_leaf_icon = ' '
  let g:vimfiler_tree_opened_icon = '▾'
  let g:vimfiler_tree_closed_icon = '▸'
  let g:vimfiler_file_icon = '-'
  let g:vimfiler_marked_file_icon = '*'

  nnoremap <silent><F9> :VimFilerExplorer<CR>
  inoremap <silent><F9> <Esc>:VimFilerExplorer<CR>
  vnoremap <silent><F9> <Esc>:VimFilerExplorer<CR>
  call neobundle#untap()
endif

NeoBundleLazy 'sjl/gundo.vim', {
      \   'autoload': { 'commands': [ 'GundoToggle' ] },
      \ }
if neobundle#tap('gundo.vim')
  nnoremap <F11> :GundoToggle<CR>
  call neobundle#untap()
endif

NeoBundle 'suan/vim-instant-markdown', {
      \   'build': {
      \     'mac':     'npm install -g instant-markdown-d',
      \     'unix':    'npm install -g instant-markdown-d',
      \     'cygwin':  'npm install -g instant-markdown-d',
      \     'windows': 'npm install -g instant-markdown-d',
      \   },
      \   'gui': 1,
      \ }
if neobundle#tap('vim-instant-markdown')
  let g:instant_markdown_autostart = 0
  let g:instant_markdown_slow = 1
  call neobundle#untap()
endif

NeoBundle 'tpope/vim-fugitive'

NeoBundleLazy 'tyru/restart.vim', {
      \   'autoload': { 'commands': 'Restart' },
      \   'gui': 1
      \ }

" ------------------------------------------------------------------------------
" commands
NeoBundle 'gelguy/Cmd2.vim'
if neobundle#tap('Cmd2.vim')
  " Update speed, default: 20
  let g:Cmd2_loop_sleep = 5

  " Require at least 0 chars typed
  let g:Cmd2__suggest_min_length = 0

  " Only take suggests on tab
  let g:Cmd2__suggest_enter_suggest = 0

  " Cancel completion on <Esc> (instead of cancelling entire command)
  let g:Cmd2__suggest_esc_menu = 1

  function! neobundle#hooks.on_source(bundle)
    " always use Cmd2
    "nmap : :<F8>
    nmap <F8> :<F8>

    " Press F8 in cmdmode to use Cmd2
    cmap <F8> <Plug>(Cmd2Suggest)
  endfunction
  call neobundle#untap()
endif

NeoBundle 'haya14busa/incsearch.vim'
if neobundle#tap('incsearch.vim')
  map /   <Plug>(incsearch-forward)
  map ?   <Plug>(incsearch-backward)
  map g/  <Plug>(incsearch-stay)
  call neobundle#untap()
endif

NeoBundleLazy 'osyo-manga/vim-anzu', {
      \   'autoload': { 'mappings': [ '<Plug>' ], }
      \ }
if neobundle#tap('vim-anzu')
  nmap n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
  nmap N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)
  nmap * <Plug>(incsearch-nohl)<Plug>(anzu-star-with-echo)
  nmap # <Plug>(incsearch-nohl)<Plug>(anzu-sharp-with-echo)
  " show anzu
  let g:airline#extensions#anzu#enabled = 1
  call neobundle#untap()
endif

NeoBundleLazy 'osyo-manga/vim-over', {
      \   'autoload': { 'commands': [ 'OverCommandLine' ] },
      \ }
if neobundle#tap('vim-over')
  nmap <silent><F7> :OverCommandLine<CR>
  vmap <silent><F7> <Esc>:OverCommandLine<CR>
  call neobundle#untap()
endif

NeoBundle 'tpope/vim-eunuch'

NeoBundle 'tpope/vim-unimpaired'        " used for line bubbling commands on osx

" Auto generate tags
" The bitbucket remote is updated more frequently
NeoBundle 'bitbucket:ludovicchabant/vim-gutentags', {
      \   'disabled': !executable("ctags"),
      \ }
if neobundle#tap('vim-gutentags')
  let g:gutentags_cache_dir = expand("$VIM_DOTFILES/.tags")
  call neobundle#untap()
endif

" ------------------------------------------------------------------------------
" autocomplete

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

  function! neobundle#hooks.on_source(bundle)
    " from the github page: <CR> cancels completion and inserts newline
    inoremap <silent><CR> <C-r>=<SID>my_cr_function()<CR>
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

  function! neobundle#hooks.on_source(bundle)
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
  vmap <Leader>a"  :Tabularize /"<CR>
  vmap <Leader>a& :Tabularize /&<CR>
  vmap <Leader>a- :Tabularize /-<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>af :Tabularize /=>/<CR>
  " align the following without moving them
  vmap <leader>a: :Tabularize /:\zs/l0l1<CR>
  vmap <leader>a, :Tabularize /,\zs/l0l1<CR>
  call neobundle#untap()
endif

" viv, v, v to expand surround selection
NeoBundle 'gorkunov/smartpairs.vim'
if neobundle#tap('smartpairs.vim')
  " disable default mappings m and M since they conflict with easypairs
  " ubermode is enough
  let g:smartpairs_nextpairs_key_i = ''
  let g:smartpairs_nextpairs_key_a = ''
  call neobundle#untap()
endif

NeoBundle 'lfilho/cosco.vim'
if neobundle#tap('cosco.vim')
  autocmd FileType javascript,css,php
        \ nnoremap <silent>;; :call cosco#commaOrSemiColon()<CR>
  autocmd FileType javascript,css,php
        \ inoremap <silent>;; <C-O>:call cosco#commaOrSemiColon()<CR>
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
      \   'disabled': v:progname == 'nvim' || !(has("python") || has("python3")),
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
    let g:syntastic_mode_map['passive_filetypes'] = [ 'html', ]
  endif

  let g:syntastic_error_symbol         = '✗'
  let g:syntastic_style_error_symbol   = '✠'
  let g:syntastic_warning_symbol       = '∆'
  let g:syntastic_style_warning_symbol = '≈'

  " ignore angular attrs
  let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

  let g:syntastic_coffeescript_checkers = ['coffee', 'coffeelint']
  let g:syntastic_php_checkers = ['php', 'phplint', 'phpmd']
  let g:syntastic_python_checkers = ['flake8']
  let g:syntastic_shell_checkers = ['bashate', 'shellcheck']
  let g:syntastic_zsh_checkers = ['zsh']
  call neobundle#untap()
endif

NeoBundle 'vim-scripts/PreserveNoEOL', {
      \   'disabled': v:progname == 'nvim' || !(has("python") || has("python3")),
      \ }

" ------------------------------------------------------------------------------
" Language specific
"
" Git --------------------------------------------------------------------------
NeoBundle 'tpope/vim-git'               " creates gitconfig, gitcommit, rebase

NeoBundle 'rhysd/committia.vim'
if neobundle#tap('committia.vim')
  let g:committia_open_only_vim_starting = 1
  let g:committia_use_singlecolumn = 'always'
  call neobundle#untap()
endif

" HTML and generators ----------------------------------------------------------
NeoBundleLazy 'othree/html5.vim', {
      \   'autoload': { 'filetypes': ['html', 'php'] },
      \ }

NeoBundleLazy 'digitaltoad/vim-jade', { 'autoload': { 'filetypes': ['jade'] } }

NeoBundle 'tpope/vim-haml'              " creates haml, sass, scss filetypes

NeoBundle 'vim-scripts/HTML-AutoCloseTag'

" JavaScript / CoffeeScript ----------------------------------------------------
" NeoBundleLazy 'facebook/vim-flow', {
"       \   'autoload': { 'filetypes': 'javascript' },
"       \   'build': {
"       \     'mac': 'npm install -g flow-bin',
"       \     'unix': 'npm install -g flow-bin'
"       \   }
"       \ }

NeoBundleLazy 'heavenshell/vim-jsdoc', {
      \   'autoload': {
      \     'filetypes': ['html', 'javascript', 'php'],
      \     'commands': ['JsDoc'],
      \   }
      \ }
if neobundle#tap('vim-jsdoc')
  let g:jsdoc_default_mapping = 0
  let g:jsdoc_underscore_private = 1
  autocmd vimrc FileType javascript nnoremap <Leader>pd :JsDoc<CR>
  autocmd vimrc FileType javascript vnoremap <Leader>pd :JsDoc<CR>
  call neobundle#untap()
endif

" syntax highlighting for jQuery
NeoBundleLazy 'itspriddle/vim-jquery', {
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
      \   'disabled': !has('ruby') || !executable("coffeetags"),
      \ }
if neobundle#tap('CoffeeTags')
  let g:CoffeeAutoTagFile="$VIM_DOTFILES/.tags/tags"
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
  call neobundle#untap()
endif

" react/JSX syn highlighting for .cjsx
NeoBundle 'mtscout6/vim-cjsx'

" react/JSX syn highlighting for .jsx
NeoBundleLazy 'mxw/vim-jsx', { 'depends': 'vim-javascript' }

NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {
      \   'autoload': { 'filetypes': ['javascript', 'coffee'] }
      \ }

" Parameter completion
NeoBundleLazy 'othree/jspc.vim', {
      \   'autoload': { 'filetypes': ['javascript', 'coffee'] }
      \ }

" explicitly compatible with
"   vim-javascript-syntax
"   vim-javascript-libraries-syntax
"   vim-jsx
" replaces 'jelera/vim-javascript-syntax', {
NeoBundleLazy 'othree/yajs.vim', {
      \   'autoload': { 'filetypes': ['html', 'javascript', 'php'] }
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
  let g:pdv_template_dir = expand("$VIM_DOTFILES/bundle/pdv/templates")
  autocmd vimrc FileType php nnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>
  autocmd vimrc FileType php vnoremap <Leader>pd :call pdv#DocumentCurrentLine()<CR>
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
NeoBundle 'Rykka/colorv.vim', { 'gui': 1 }
if neobundle#tap('colorv.vim')
  let g:colorv_preview_ftype  = "css,html,less,sass,scss"
  let g:colorv_cache_fav      = expand("$VIM_DOTFILES/.colorv_cache_fav")
  let g:colorv_cache_file     = expand("$VIM_DOTFILES/.colorv_cache_file")
  call neobundle#untap()
endif

NeoBundle 'cakebaker/scss-syntax.vim'   " creates scss.css
if neobundle#tap('vim-css3-syntax')
  autocmd vimrc FileType scss setlocal iskeyword+=-
  call neobundle#untap()
endif

NeoBundle 'groenewege/vim-less'         " creates less filetype

NeoBundleLazy 'hail2u/vim-css3-syntax', {
      \   'autoload': { 'filetypes': ['css', 'scss'] },
      \ }
if neobundle#tap('vim-css3-syntax')
  " fix highlighting problems on: vertical-align, box-shadow, and others
  autocmd vimrc FileType css setlocal iskeyword+=-
  call neobundle#untap()
endif

" Better @media syntax highlighting
NeoBundle 'JulesWang/css.vim', {
      \   'autoload': { 'filetypes': ['css', 'scss'] },
      \ }

" Twig -------------------------------------------------------------------------
NeoBundle 'evidens/vim-twig'            " creates twig

" YAML -------------------------------------------------------------------------
NeoBundle 'ingydotnet/yaml-vim'

call neobundle#end()

if !has('vim_starting')
  " Call on_source hook when reloading .vimrc.
  call neobundle#call_hook('on_source')
endif

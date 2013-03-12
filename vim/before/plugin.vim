""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin settings
" See keybindings for plugin activation keybindings

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
let g:NERDTreeShowHidden = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" yankring settings
let g:yankring_history_file           = '.vim/.yankring-history'
let g:yankring_manual_clipboard_check = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ctrl-p
" We don't want to use Ctrl-p as the mapping because
" it interferes with YankRing (paste, then hit ctrl-p)
let g:ctrlp_map            = '<C-t>'
let g:ctrlp_jump_to_buffer = 2        " Jump to tab AND buffer if already open
let g:ctrlp_split_window   = 1        " <CR> = New Tab
let g:ctrlp_max_files      = 2500
let g:ctrlp_max_depth      = 20

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" run syntastic on file open
let g:syntastic_check_on_open       = 1
let g:syntastic_auto_loc_list       = 1
let g:syntastic_enable_signs        = 1
let g:syntastic_enable_highlighting = 1
"let g:syntastic_mode_map = { 'mode': 'active',
"                           \ 'active_filetypes': ['js','php','html,scss,css,sass,less'],
"                           \ 'passive_filetypes': [] }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplcache
let g:neocomplcache_enable_at_startup            = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion   = 1
let g:neocomplcache_enable_smart_case            = 1
" default # of completions is 100, that's crazy
let g:neocomplcache_max_list = 25
" words less than 3 letters long aren't worth completing
let g:neocomplcache_auto_completion_start_length = 3
" This makes sure we use neocomplcache completefunc instead of
" the one in rails.vim, otherwise this plugin will crap out
let g:neocomplcache_force_overwrite_completefunc = 1
" Enable omni completion.
if has("autocmd")
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
endif
" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-gitgutter off
let g:gitgutter_enabled = 0

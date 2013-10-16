""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin settings
" See keybindings for plugin activation keybindings

" Supertab reverse Tab behavior
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-n>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lightline

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
let g:NERDTreeShowHidden = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ctrl-p
" We don't want to use Ctrl-p as the mapping because
" it interferes with YankRing (paste, then hit ctrl-p)
let g:ctrlp_map            = '<C-t>'
let g:ctrlp_jump_to_buffer = 2        " Jump to tab AND buffer if already open
let g:ctrlp_split_window   = 1        " <CR> = New Tab
let g:ctrlp_max_depth      = 10

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplcache
let g:neocomplcache_enable_at_startup            = 1
let g:neocomplcache_enable_smart_case            = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion   = 1
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-gitgutter off
let g:gitgutter_enabled = 0

let g:syntastic_aggregate_errors         = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_enable_signs             = 1
let g:syntastic_enable_highlighting      = 1
let g:syntastic_loc_list_height          = 3

let g:syntastic_error_symbol         = '✗'
let g:syntastic_style_error_symbol   = '✠'
let g:syntastic_warning_symbol       = '∆'
let g:syntastic_style_warning_symbol = '≈'

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

let g:syntastic_ignore_files = [
      \ '\m\.min\.js$',
      \ '\m\.min\.css$'
      \ ]

" ignore angular attrs
let g:syntastic_html_tidy_ignore_errors = [" proprietary attribute \"ng-"]

let g:syntastic_coffeescript_checkers = ['coffee', 'coffeelint']
let g:syntastic_javascript_checkers   = ['eslint']
let g:syntastic_javascript_eslint_args = '--no-ignore'
let g:syntastic_lua_checkers          = ['luac', 'luacheck']
"let g:syntastic_lua_luacheck_args     = '--config ' . system("luacheckrc")
let g:syntastic_php_checkers          = ['php', 'phpcs', 'phplint', 'phpmd']
let g:syntastic_python_checkers       = ['prospector', 'python']
let g:syntastic_shell_checkers        = ['bashate', 'shellcheck']
let g:syntastic_zsh_checkers          = ['zsh']


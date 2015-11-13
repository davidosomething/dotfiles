scriptencoding utf-8

let g:syntastic_aggregate_errors         = 1
"let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_enable_signs             = 1
let g:syntastic_enable_highlighting      = 1
let g:syntastic_loc_list_height          = 3

" Screws up deleting quotes and typing
let g:syntastic_nested_autocommands      = 1

let g:syntastic_error_symbol         = '✗'
let g:syntastic_style_error_symbol   = '✠'
let g:syntastic_warning_symbol       = '∆'
let g:syntastic_style_warning_symbol = '≈'

let g:syntastic_ignore_files = [
      \ '\m\.min\.js$',
      \ '\m\.min\.css$',
      \ ]

let g:syntastic_mode_map = {
      \   'mode': 'active',
      \   'passive_filetypes': [ 'html' ],
      \ }

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


scriptencoding utf-8

" Checking
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq   = 0
let g:syntastic_mode_map = {
      \   'mode': 'active',
      \   'passive_filetypes': [ ],
      \ }

" Display
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_loc_list_height          = g:dko_loc_list_height
let g:syntastic_aggregate_errors         = 1

" Signs
let g:syntastic_enable_signs         = 1
let g:syntastic_error_symbol         = 'X'
let g:syntastic_style_error_symbol   = 'x'
let g:syntastic_warning_symbol       = '!'
let g:syntastic_style_warning_symbol = '≈'

let g:syntastic_ignore_files = [
      \ '\m\.min\.js$',
      \ '\m\.min\.css$',
      \ ]

" ============================================================================
" Checker: HTML, Handlebars
" ============================================================================

let s:dko_ignore_html_tidy = [
      \   ' proprietary attribute "ng-',
      \   ' proprietary attribute "itemprop',
      \   ' proprietary attribute "itemscope',
      \ ]

" Ignore handlebars stuff in tidy
let s:dko_ignore_html_tidy_handlebars = [
      \   " allowed in <head> elements",
      \   "{{",
      \ ]

function! s:DKO_SyntasticHtml()
  let g:syntastic_html_tidy_ignore_errors = s:dko_ignore_html_tidy
endfunction

function! s:DKO_SyntasticHandlebars()
  let g:syntastic_html_tidy_ignore_errors = s:dko_ignore_html_tidy
        \ + s:dko_ignore_html_tidy_handlebars
endfunction

augroup vimrc
  autocmd BufEnter,BufReadPost,BufWritePost *.html
        \ :call s:DKO_SyntasticHtml()
  autocmd BufEnter,BufReadPost,BufWritePost *.hbs
        \ :call s:DKO_SyntasticHandlebars()
augroup end

" ============================================================================
" Checker: JS, Coffee
" ============================================================================

let g:syntastic_coffeescript_checkers  = ['coffee', 'coffeelint']

let g:syntastic_javascript_checkers    = ['eslint']
let g:syntastic_javascript_eslint_args = '--no-ignore'

" ============================================================================
" Checker: Lua
" ============================================================================

let g:syntastic_lua_checkers           = ['luac', 'luacheck']
"let g:syntastic_lua_luacheck_args     = '--config ' . system("luacheckrc")
"
" ============================================================================
" Checker: PHP
" ============================================================================

let g:syntastic_php_checkers           = ['php', 'phpcs', 'phplint', 'phpmd']

" ============================================================================
" Checker: Python
" ============================================================================

let g:syntastic_python_checkers        = ['prospector', 'python']

" ============================================================================
" Checker: Shell
" ============================================================================

let g:syntastic_shell_checkers         = ['bashate', 'shellcheck']
let g:syntastic_zsh_checkers           = ['zsh']

" ============================================================================
" Checker: VimL
" ============================================================================

" Syntastic checks if they're installed so don't need to check here.
let g:syntastic_vim_checkers           = ['vimlint', 'vint']


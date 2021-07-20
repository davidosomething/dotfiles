" plugin/plug-neomake.vim
scriptencoding utf-8

if !dkoplug#IsLoaded('neomake') | finish | endif

" ============================================================================
" Output
" ============================================================================

let g:neomake_echo_current_error = 0 " neovim virtualtext is enough
let g:neomake_highlight_columns = 0
let g:neomake_open_list = 2
let g:neomake_open_list_resize_existing = 0 " using vim-qf_resize
let g:neomake_serialize = 0 " aggregate errors
let g:neomake_error_sign    = { 'text': '⚑', 'texthl': 'NeomakeErrorSign' }
let g:neomake_warning_sign  = { 'text': '⚑', 'texthl': 'NeomakeWarningSign' }
let g:neomake_message_sign  = { 'text': '⚑', 'texthl': 'NeomakeMessageSign' }
let g:neomake_info_sign     = { 'text': '⚑', 'texthl': 'NeomakeInfoSign' }

" ============================================================================
" Global maker settings
" ============================================================================

" Disabled java makers
" https://github.com/neomake/neomake/issues/875
let g:neomake_java_enabled_makers = [ 'checkstyle' ]
let g:neomake_java_checkstyle_xml =
      \ expand('$DOTFILES/checkstyle/google_checks.xml')

" flake8 is pycodestyle(pep8)+pyflakes+pydocstyle
" preferred over pylama (other multi-runner) for now
let g:neomake_python_enabled_makers = [ 'flake8' ]

let g:neomake_sh_bashate_maker = {
      \   'exe': 'bashate',
      \   'args': ['--ignore=E003,E005,E006,E011,E043'],
      \   'errorformat': '%f:%l:%c: %t%n %m',
      \ }
let g:neomake_sh_shellcheck_args = [
      \   '--format=gcc',
      \   '--external-sources',
      \   '--exclude=SC1090,SC2148',
      \   '--shell=sh',
      \ ]
let g:neomake_sh_enabled_makers = neomake#makers#ft#sh#EnabledMakers() + [
      \   'bashate',
      \ ]

" ============================================================================
" Prefer coc.nvim
" ============================================================================

if dkoplug#IsLoaded('coc.nvim')
  let g:neomake_css_enabled_makers = []
  let g:neomake_dockerfile_enabled_makers = []
  let g:neomake_javascript_enabled_makers = []
  let g:neomake_markdown_enabled_makers = []
  let g:neomake_vim_enabled_makers = []
endif

" ============================================================================
" echint
" ============================================================================

function! g:PostprocessEchint(entry) abort
  return a:entry.text =~# 'did not pass EditorConfig validation'
        \ ? extend(a:entry, { 'valid': -1 })
        \ : a:entry
endfunction

let g:echint_whitelist = [
      \   'gitconfig',
      \   'dosini',
      \   'lua',
      \   'php',
      \   'sh',
      \   'vim',
      \   'yaml',
      \   'zsh',
      \]
" Excludes things like python, which has pep8.
for s:ft in g:echint_whitelist
  let s:safe_ft = neomake#utils#get_ft_confname(s:ft)
  let g:neomake_{s:safe_ft}_echint_maker = dko#neomake#NpxMaker({
        \   'maker': 'echint',
        \   'ft': s:ft,
        \   'errorformat': '%E%f:%l %m',
        \   'postprocess': function('PostprocessEchint'),
        \ }, 'global')
endfor
unlet s:ft
unlet s:safe_ft

" ============================================================================
" Buffer filetype settings
" Use BufWinEnter because it runs after modelines, which might change the
" filetype. Setup functions should check filetype if not matching by extension
" ============================================================================

augroup dkoneomake
  autocmd!
  autocmd User vim-pyenv-activate-post
        \ call dko#neomake#python#ActivatedPyenv()
  autocmd User vim-pyenv-dectivate-post
        \ call dko#neomake#python#DeactivatedPyenv()
  autocmd BufNewFile,BufReadPre *
        \ call dko#neomake#bash#Setup()
augroup END

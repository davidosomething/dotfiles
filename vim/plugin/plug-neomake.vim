" plugin/plug-neomake.vim
scriptencoding utf-8

if !dkoplug#IsLoaded('neomake') | finish | endif

" ============================================================================
" Map
" ============================================================================

execute dko#MapAll({ 'key': '<F7>', 'command': 'Neomake!' })

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

" Run these makers by default on :Neomake
let g:neomake_javascript_enabled_makers = [ 'eslint' ]

" flake8 is pycodestyle(pep8)+pyflakes+pydocstyle
" preferred over pylama (other multi-runner) for now
let g:neomake_python_enabled_makers = [ 'flake8' ]

let g:neomake_sh_bashate_maker = {
      \   'exe': 'bashate',
      \   'args': ['--ignore=E003,E005,E006,E011'],
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
" Buffer filetype settings
" Use BufWinEnter because it runs after modelines, which might change the
" filetype. Setup functions should check filetype if not matching by extension
" ============================================================================

call dko#neomake#EchintCreate()

augroup dkoneomake
  autocmd!

  autocmd User vim-pyenv-activate-post
        \ call dko#neomake#python#ActivatedPyenv()
  autocmd User vim-pyenv-dectivate-post
        \ call dko#neomake#python#DeactivatedPyenv()
  autocmd FileType sh           call dko#neomake#bash#Setup()
  autocmd FileType javascript   call dko#neomake#javascript#Setup()
  autocmd FileType lua          call dko#neomake#lua#Setup()
  autocmd FileType markdown     call dko#neomake#markdown#Setup()
  autocmd FileType php          call dko#neomake#php#Setup()
  autocmd FileType scss         call dko#neomake#scss#Setup()
  autocmd FileType zsh          let b:neomake_zsh_enabled_makers = [ 'zsh' ]
  autocmd FileType *            call dko#neomake#EchintSetup()

  " Keep this last so all the other autocmds happen first
  autocmd BufWritePost *        call dko#neomake#MaybeRun()
augroup END

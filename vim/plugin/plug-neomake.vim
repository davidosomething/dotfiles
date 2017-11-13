" plugin/plug-neomake.vim
scriptencoding utf-8

if !dkoplug#IsLoaded('neomake') | finish | endif

augroup dkoneomake
  autocmd!
augroup END

" ============================================================================
" Map
" ============================================================================

execute dko#MapAll({ 'key': '<F6>', 'command': 'Neomake' })
execute dko#MapAll({ 'key': '<F7>', 'command': 'Neomake!' })

" ============================================================================
" Output
" ============================================================================

let g:neomake_open_list   = 2
let g:neomake_serialize   = 0 " aggregate errors
let g:neomake_highlight_columns = 0
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
let g:neomake_javascript_enabled_makers =
      \ executable('eslint') ? [ 'eslint' ] : []

" flake8 is pycodestyle(pep8)+pyflakes+pydocstyle
" preferred over pylama (other multi-runner) for now
let g:neomake_python_enabled_makers = [ 'flake8' ]

" ============================================================================
" Buffer filetype settings
" Use BufWinEnter because it runs after modelines, which might change the
" filetype. Setup functions should check filetype if not matching by extension
" ============================================================================

call dko#neomake#EchintCreate()

" Init all buffers; ft may be set by shebang or modeline
autocmd dkoneomake FileType sh
      \ call dko#neomake#ShellcheckPosix()

autocmd dkoneomake FileType javascript
      \ call dko#neomake#javascript#Setup()

autocmd dkoneomake FileType markdown
      \ call dko#neomake#markdown#Setup()

autocmd dkoneomake FileType php
      \   call dko#neomake#LocalMaker(dko#neomake#php#phpcs)
      \ | call dko#neomake#php#Phpcs()
      \ | call dko#neomake#php#Phpmd()

autocmd dkoneomake FileType scss
      \ call dko#neomake#scss#Setup()

autocmd dkoneomake FileType *
      \ call dko#neomake#EchintSetup()

autocmd dkoneomake User vim-pyenv-activate-post
      \ call dko#neomake#python#ActivatedPyenv()
autocmd dkoneomake User vim-pyenv-dectivate-post
      \ call dko#neomake#python#DeactivatedPyenv()

" ============================================================================

" Keep this last so all the other autocmds happen first
autocmd dkoneomake BufWritePost * call dko#neomake#MaybeRun()

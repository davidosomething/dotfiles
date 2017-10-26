" plugin/plug-neomake.vim
scriptencoding utf-8

if !dkoplug#plugins#IsLoaded('neomake') | finish | endif

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

let g:neomake_open_list   = 0
let g:neomake_list_height = g:dko_loc_list_height
let g:neomake_serialize   = 0 " aggregate errors
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

let g:neomake_vim_enabled_makers = [ 'vimlparser', 'vint' ]

let g:neomake_vim_vimlparser_maker = {
      \   'exe':         'vimlparser',
      \   'args':        [],
      \   'errorformat': '%E%f:%l:%c: %n: %m',
      \ }

" ============================================================================
" Buffer filetype settings
" ============================================================================

autocmd dkoneomake FileType javascript
      \   call dkoproject#neomake#LocalMaker(dkoproject#neomake#javascript#local_eslint)
      \ | call dkoproject#neomake#LocalMaker(dkoproject#neomake#javascript#local_jshint)
      \ | call dkoproject#neomake#javascript#SetMaker()
      "\ | call dkoproject#neomake#LocalMaker(dkoproject#neomake#javascript#local_flow)

autocmd dkoneomake FileType markdown.pandoc,markdown
      \ call dkoproject#neomake#markdown#Markdownlint()

autocmd dkoneomake FileType php
      \   call dkoproject#neomake#LocalMaker(dkoproject#neomake#php#local_phpcs)
      \ | call dkoproject#neomake#php#Phpcs()
      \ | call dkoproject#neomake#php#Phpmd()

autocmd dkoneomake BufNewFile,BufRead *.sh,dot.profile
      \   call dkoproject#neomake#sh#ShellcheckPosix()

autocmd dkoneomake FileType scss
      \   call dkoproject#neomake#LocalMaker(dkoproject#neomake#scss#local_sasslint)
      \ | call dkoproject#neomake#scss#Sasslint()
      \ | call dkoproject#neomake#scss#SetMaker()

autocmd dkoneomake User vim-pyenv-activate-post
      \   call dkoproject#neomake#python#ActivatedPyenv()
autocmd dkoneomake User vim-pyenv-dectivate-post
      \   call dkoproject#neomake#python#DeactivatedPyenv()

" ============================================================================

" Keep this last so all the other autocmds happen first
autocmd dkoneomake BufWritePost * call dkoproject#neomake#MaybeRun()

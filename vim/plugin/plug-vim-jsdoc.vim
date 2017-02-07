" plugin/plug-vim-jsdoc.vim

if !dko#IsPlugged('vim-jsdoc') | finish | endif

augroup dkovimjsdoc
  autocmd FileType javascript *
        \ nmap  <buffer><special>  <Leader>pd  <Plug>(jsdoc)
augroup END

let g:jsdoc_return = 0

" @public, @private
let g:jsdoc_underscore_private = 1
"let g:jsdoc_access_descriptions = 2

let g:jsdoc_enable_es6 = 1


" Add param type when documenting args
" key is regex to match param name
" The match is done via matchstr() (so magic mode is on -- escape ?)
let g:jsdoc_custom_args_regex_only = 1
let g:jsdoc_custom_args_hook = {
      \   '^\$': {
      \     'type': '{jQuery}'
      \   },
      \   '^_\?is': {
      \     'type': '{Boolean}'
      \   },
      \   '\cdate$': {
      \     'type': '{Date}'
      \   },
      \   '\cel$': {
      \     'type': '{Element}'
      \   },
      \   '\c\(err\|error\)$': {
      \     'type': '{Error}'
      \   },
      \   '^\(e\|evt\|event\)$': {
      \     'type': '{Event}'
      \   },
      \   '\c\(callback\|cb\|done\)$': {
      \     'description': 'Callback function',
      \     'type': '{Function}',
      \   },
      \   '\chandler$': {
      \     'description': 'Event handler',
      \     'type': '{Function}'
      \   },
      \   '^on': {
      \     'description': 'Event handler',
      \     'type': '{Function}'
      \   },
      \   '\chandlers$': {
      \     'description': 'Event handlers',
      \     'type': '{Function[]}'
      \   },
      \   '^i$': {
      \     'type': '{Number}'
      \   },
      \   '\c\(width\|height\)': {
      \     'type': '{Number}'
      \   },
      \   '\c\(data\|options\)$': {
      \     'type': '{Object}'
      \   },
      \   '\cpromise$': {
      \     'type': '{Promise}'
      \   },
      \   '\cregex': {
      \     'type': '{RegExp}'
      \   },
      \   '\c\(description\|message\|title\|url\)': {
      \     'type': '{String}'
      \   },
      \   '\cmessages?': {
      \     'type': '{String[]}'
      \   },
      \ }


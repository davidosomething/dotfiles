" plugin/plug-neoformat.vim
scriptencoding utf-8

if !dkoplug#IsLoaded('neoformat') | finish | endif

" function! g:DKO_OverridePrettierFormatter() abort
"   let l:bin_candidates = [
"         \   dko#project#GetBin('node_modules/.bin/prettier-eslint'),
"         \   dko#project#GetBin('node_modules/.bin/prettier'),
"         \   executable('prettier-eslint') ? 'prettier-eslint' : '',
"         \   executable('prettier') ? 'prettier' : '',
"         \ ]
"   let l:bin = dko#First(l:bin_candidates)
"   if empty(l:bin) | return | endif
"
"   let l:args =  [ '--stdin' ]
"   let l:eslint = dko#project#GetDir('node_modules/eslint') " Module, not bin
"   if !empty(l:eslint)
"     let l:args += [ '--eslint-path', l:eslint ]
"   endif
"
"   let l:eslintrc = dko#project#GetEslintrc()
"   if !empty(l:eslintrc)
"     let l:args += [ '--eslint-config', l:eslintrc ]
"   endif
"
"   let l:prettier = dko#project#GetDir('node_modules/prettier') " Module, not bin
"   if !empty(l:prettier)
"     let l:args += [ '--prettier-path',  l:prettier ]
"   endif
"
"   let l:formatprg = escape(l:bin . ' ' . join(l:args, ' '), ' \')
"   return l:formatprg
" endfunction

function! s:PrettierConfig() abort
  return expand('$DOTFILES/prettier/prettier.config.js')
endfunction

let g:neoformat_javascript_dkoprettier = {
      \   'exe':    'prettier',
      \   'args':   [
      \     '--config', s:PrettierConfig(),
      \     '--stdin',
      \   ],
      \   'stdin':  1,
      \ }

let g:neoformat_javascript_dkoprettiereslint = {
      \   'exe':    'prettier-eslint',
      \   'args':   [
      \     '--config', s:PrettierConfig(),
      \     '--stdin',
      \   ],
      \   'stdin':  1,
      \ }

let g:neoformat_enabled_css = ['dkoprettier']
let g:neoformat_enabled_java = ['uncrustify']
let g:neoformat_enabled_javascript = ['dkoprettier']
let g:neoformat_enabled_json = ['dkoprettier']
let g:neoformat_enabled_python = ['autopep8', 'isort']
let g:neoformat_enabled_scss = ['dkoprettier']

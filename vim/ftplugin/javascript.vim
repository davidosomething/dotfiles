" ftplugin/javascript.vim

call dko#TwoSpace()

"
" Settings for plugins that need to be available before plug loads
"

" matchit
" from https://github.com/romainl/dotvim/blob/efb9257da7b0d1c6e5d9cfb1e7331040fd90b6c1/bundle/lang-javascript/after/ftplugin/javascript.vim#L10
let b:match_words = '\<function\>:\<return\>,'
  \ . '\<do\>:\<while\>,'
  \ . '\<switch\>:\<case\>:\<default\>,'
  \ . '\<if\>:\<else\>,'
  \ . '\<try\>:\<catch\>:\<finally\>'

let s:cpo_save = &cpoptions
set cpoptions&vim

" Require to import
nnoremap r2i
      \ :<C-U>s/\(const\) \(\w*\)\s*=\srequire(\('.*'\))/import \2 from \3<CR>

if g:dko_use_completion && dkoplug#IsLoaded('jspc.vim')
  " jspc#omni normally extends javascriptcomplete on param pattern match.
  " Unset the omnifunc so it doesn't extend anything. This way only paramter
  " completion is forwarded to NCM
  setlocal omnifunc=
endif

" Set up native eslint making so we can debug eslint configs
let &l:makeprg = 'cd ' . dko#project#GetRoot() . ' && npx eslint -f compact %'
setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %trror\ -\ %m
setlocal errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %tarning\ -\ %m
setlocal errorformat+=%-G\s%#
setlocal errorformat+=%-G\s%#%\\d%\\+\ problems%#

let &cpoptions = s:cpo_save
unlet s:cpo_save

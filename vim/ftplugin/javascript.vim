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

" Require to import
nmap r2i :<C-U>s/\(const\) \(\w*\)\s*=\srequire(\('.*'\))/import \2 from \3<CR>

if g:dko_use_completion && dko#IsPlugged('jspc.vim')
  " jspc#omni normally extends javascriptcomplete on param pattern match.
  " Unset the omnifunc so it doesn't extend anything. This way only paramter
  " completion is forwarded to NCM
  set omnifunc=
endif

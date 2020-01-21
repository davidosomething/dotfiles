" after/syntax/sh/embed-awk.vim
"
" Embed awk highlighting
" See :h *sh-embed*

if exists('b:current_syntax')
  unlet b:current_syntax
endif

" Silence if syntax/awk.vim not in runtime (e.g. in a crappy vim)
try
  syn include @AWKScript syntax/awk.vim
catch
endtry

syn region AWKScriptCode matchgroup=AWKCommand start=+[=\\]\@<!'+ skip=+\\'+ end=+'+ contains=@AWKScript contained
syn region AWKScriptEmbedded matchgroup=AWKCommand start=+\<awk\>+ skip=+\\$+ end=+[=\\]\@<!'+me=e-1 contains=@shIdList,@shExprList2 nextgroup=AWKScriptCode
syn cluster shCommandSubList add=AWKScriptEmbedded
hi def link AWKCommand Type

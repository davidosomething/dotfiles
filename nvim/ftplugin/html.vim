" ftplugin/html.vim
" more settings (overrides) in after/ftplugin/html.vim

" These are for default html.vim but I'm probably using othree/html5.vim
" see :help html-indent
let g:html_indent_script1 = 'zero'
let g:html_indent_style1 = 'zero'
" Don't indent first child of these tags
let g:html_indent_autotags = 'html,head,body'

" ============================================================================
" othree/html5.vim settings
" ============================================================================

if dkoplug#Exists('html5.vim')
  " fixed array mode as of https://github.com/othree/html5.vim/commit/f5bdca5153dc526623df5ae16943d1f627dc5523
  let g:html_exclude_tags = ['html', 'head', 'style', 'script', 'body']
endif


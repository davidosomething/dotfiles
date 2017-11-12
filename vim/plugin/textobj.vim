" plugin/textobj.vim
"
" vim-textobj-user text objects
" These are lazy loaded so we need the bindings to trigger the <Plug>
"

if !dkoplug#IsLoaded('vim-textobj-user') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================

function! s:MapTextobj(obj) abort
  let l:char = a:obj[0]
  execute 'omap a' . l:char . ' <Plug>(textobj-' . a:obj . '-a)'
  execute 'xmap a' . l:char . ' <Plug>(textobj-' . a:obj . '-a)'
  execute 'omap i' . l:char . ' <Plug>(textobj-' . a:obj . '-i)'
  execute 'xmap i' . l:char . ' <Plug>(textobj-' . a:obj . '-i)'
endfunction

for s:obj in [
      \   'comment',
      \   'indent',
      \   'line',
      \   'url',
      \   'xmlattr',
      \ ]
  if dkoplug#Exists('vim-textobj-' . s:obj)
    call s:MapTextobj(s:obj)
  endif
endfor

let g:textobj_lastpaste_no_default_keymappings = 1
if dkoplug#Exists('textobj-lastpaste')
  omap iP <Plug>(textobj-lastpaste-i)
  xmap iP <Plug>(textobj-lastpaste-i)
endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

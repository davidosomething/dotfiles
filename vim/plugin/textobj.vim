" plugin/textobj.vim
"
" vim-textobj-user text objects
" These are lazy loaded so we need the bindings to trigger the <Plug>
"

if !dko#IsPlugged('vim-textobj-user') | finish | endif

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
      \   'indent',
      \   'line',
      \   'url',
      \   'xmlattr',
      \ ]
  if dko#IsPlugged('vim-textobj-' . s:obj)
    call s:MapTextobj(s:obj)
  endif
endfor

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

" autoload/dko/edit.vim

" ============================================================================
" Quick edit
" ec* - Edit closest (find upwards)
" er* - Edit from dko#project#GetRoot()
" ============================================================================

" @param {String} file
function! dko#edit#Edit(file) abort
  if empty(a:file)
    echomsg 'File not found: ' . a:file
    return
  endif
  execute 'edit ' . a:file
endfunction

" This executes instead of returns string so the mapping can noop when file
" not found.
" @param {String} file
function! dko#edit#EditClosest(file) abort
  let l:file = findfile(a:file, '.;')
  call dko#edit#Edit(l:file)
endfunction

" As above, this noops if file not found
" @param {String} file
function! dko#edit#EditRoot(file) abort
  let l:file = dko#project#GetFile(a:file)
  call dko#edit#Edit(l:file)
endfunction

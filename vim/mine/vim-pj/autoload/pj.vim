" autoload/pj.vim
"
" package.json file ops
"

let s:jsons = {}

" @param {String} [filepath] key in s:jsons
function! pj#GetJson(...) abort
  let l:filepath = get(a:, 1, get(b:, 'PJ_file', ''))
  if empty(l:filepath)
    return {}
  endif

  " Parse JSON file if not cached
  let s:jsons[l:filepath] =
        \ get(s:jsons, l:filepath, json_decode(readfile(l:filepath)))

  return s:jsons[l:filepath]
endfunction

" Invalidate a JSON dict for the given path. Probably used if editing the
" package.json at the time.
"
" @param {String} filepath key in s:jsons
" @return {Boolean} success
function! pj#Invalidate(...) abort
  let l:filepath = get(a:, 1, get(b:, 'PJ_file', ''))
  if !empty(l:filepath) && has_key(s:jsons, l:filepath)
    call remove(s:jsons, l:filepath)
    return 1
  endif
  return 0
endfunction

" Get a value from the buffer's decoded package.json dict
"
" @param {String} ... keys to get, e.g. ('repository', 'url')
" @return {Mixed} empty dict if not found
function! pj#GetValue(...) abort
  if !exists('b:PJ_file')
    echoerr 'This buffer has no package.json path in b:PJ_file.'
    return {}
  endif

  let l:hash = pj#GetJson()
  if empty(l:hash)
    echoerr 'The package.json for this buffer is empty.'
    return {}
  endif

  " There must be a better way to deep traverse an object...
  let l:result = l:hash
  for l:deep_key in a:000
    " Requested more keys than there were available
    if type(l:result) !=# 4
      return {}
    endif

    let l:result = get(l:result, l:deep_key, {})
    if empty(l:result)
      return {}
    endif
  endfor
  return l:result
endfunction

" @param {String|Funcref} PJ_function
function! pj#GetPackageJsonPath(PJ_function) abort
  " Use PJ_function if string, call if funcref
  let l:path =
        \   type(a:PJ_function) ==# 1 ? a:PJ_function
        \ : type(a:PJ_function) ==# 2 ? a:PJ_function()
        \ : ''
  if empty(l:path)
    return ''
  endif

  if !filereadable(l:path)
    echoerr 'Could not read package.json at ' . l:path
    return ''
  endif

  " Expose only if file was found
  return l:path
endfunction

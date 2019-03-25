" autoload/dko/neomake.vim

" Add maker to buffer-local enabled_makers
"
" @param {string} ft
" @param {string} maker
function! dko#neomake#AddMaker(ft, maker) abort
  let l:bmakers = 'b:neomake_' . a:ft . '_enabled_makers'

  " Append to buffer local settings if exists
  if exists(l:bmakers)
    if index({l:bmakers}, a:maker) > -1 | return | endif
    let {l:bmakers} += [ a:maker ]
    return
  endif

  " Create new buffer local settings based on global settings
  try
    let {l:bmakers} = neomake#GetEnabledMakers(a:ft) + [ a:maker ]
  catch
    let {l:bmakers} = [ a:maker ]
  endtry
endfunction

" Might as well be here since echint is created for all fts
"
" @param {dict} settings to make an npx maker with
" @param {mixed} [1] pass to just return the resulting dict, omit to set on b:
" @return {dict}
function! dko#neomake#NpxMaker(settings, ...) abort
  let l:bin = get(a:settings, 'npx', a:settings['maker'])
  let l:args = get(a:settings, 'args', [])
  let l:ft = get(a:settings, 'ft', neomake#utils#get_ft_confname(&filetype))
  let l:maker = extend(copy(a:settings), {
      \   'exe': 'npx',
      \   'args': [ '--quiet', l:bin ] + l:args,
      \ })
  if !has_key(a:settings, 'cwd')
    let l:maker.cwd = '%:p:h'
  endif

  if a:0 == 0
    let b:neomake_{l:ft}_{a:settings['maker']}_maker = l:maker
  endif

  return l:maker
endfunction

" @param  {String} name of maker
" @param  {String} [a:1] ft of the maker, defaults to current buffers filetype
" @return {Boolean} true when the maker exe exists or was registered as a local
"         maker (so local exe exists)
function! dko#neomake#IsMakerExecutable(name, ...) abort
  let l:ft = get(a:, 1, &filetype)
  if empty(l:ft) | return 0 | endif

  " dko#neomake#LocalMaker successfully determined a project-local
  " bin was executable, return that instead
  if exists('b:neomake_' . l:ft . '_' . a:name . '_exe')
        \ || exists('b:neomake_' . neomake#utils#get_ft_confname(l:ft)
        \           . '_' . a:name . '_exe')
    return executable(b:neomake_{l:ft}_{a:name}_exe)
  endif

  " Don't need to sanitize
  " Use the default exe from maker definition
  let l:maker = neomake#GetMaker(a:name, l:ft)
  return !empty(l:maker) && executable(l:maker.exe)
endfunction

" Override the _exe setting of a maker and add it to _enabled_makers
"
" @param {dict} settings
" @param {string} [settings.exe] alternate exe path to use in the buffer
" @param {string} settings.ft filetype for the maker
" @param {Boolean} [settings.is_enabled] default true, auto-enable when defined
" @param {string} settings.maker name
function! dko#neomake#LocalMaker(settings) abort
  " Override maker's exe for this buffer?
  let l:exe = dko#project#GetBin(get(a:settings, 'exe', ''))
  if !empty(l:exe)
    let b:neomake_{a:settings['ft']}_{a:settings['maker']}_exe = l:exe
  endif

  " Automatically enable the maker for this buffer?
  let l:is_enabled = get(a:settings, 'is_enabled', 1)
  let l:is_executable = !empty(l:exe)
        \ || dko#neomake#IsMakerExecutable(a:settings['maker'], a:settings['ft'])

  if l:is_enabled && l:is_executable
    call add(
          \ dko#InitList('b:neomake_' . a:settings['ft'] . '_enabled_makers'),
          \ a:settings['maker'])
  endif
endfunction

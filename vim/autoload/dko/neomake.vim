" plugin/plug-neomake.vim
scriptencoding utf-8

if !dkoplug#IsLoaded('neomake') | finish | endif

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
    return executable(b:neomake_{l:ft}_{a:name}_exe)
  endif

  " Use the default exe from maker definition
  let l:maker = neomake#GetMaker(a:name, l:ft)
  return !empty(l:maker) && executable(l:maker.exe)
endfunction

" ============================================================================
" Define makers
" This should run for EVERY buffer, even though it may be slow. This way
" mono-repos may use different makers when in different dirs.
" ============================================================================

" For using local npm based makers (e.g. eslint):
" Resolve the maker's exe relative to the project of the file in buffer, as
" opposed to using the result of `system('npm bin')` since that executes
" relative to vim's working path (and gives a fake result of not in a node
" project). Lotta people doin` it wrong ಠ_ಠ

" @param {dict} settings
" @param {string} [settings.exe] alternate exe path to use in the buffer
" @param {string} settings.ft filetype for the maker
" @param {Boolean} [settings.is_enabled] default true, auto-enable when defined
" @param {string} settings.maker name
" @param {string} [settings.when] eval()'d, add local maker only if true
function! dko#neomake#LocalMaker(settings) abort
  " eval to runs with the buffer context
  if has_key(a:settings, 'when') && !eval(a:settings['when']) | return | endif

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

" @param {dict} settings to make an npx maker with
" @param {mixed} [1] pass to just return the resulting dict, omit to set on b:
" @return {dict}
function! dko#neomake#NpxMaker(settings, ...) abort
  " eval to runs with the buffer context
  if has_key(a:settings, 'when') && !eval(a:settings['when']) | return | endif

  let l:bin = get(a:settings, 'npx', a:settings['maker'])
  let l:args = get(a:settings, 'args', [])
  let l:ft = get(a:settings, 'ft', &filetype)
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

" @TODO can use neomake#configure#automake() when blacklist is implemented
function! dko#neomake#MaybeRun() abort
  if dko#IsNonFile('%') || dko#IsHelp('%') | return | endif
  " File was never written
  if empty(glob(expand('%'))) | return | endif
  Neomake
endfunction

" Always use b: list of makers; init with defaults
function! dko#neomake#InitBuffer() abort
  if empty(&filetype) || dko#IsNonFile(bufnr('%')) | return | endif
  let l:maker_list = 'b:neomake_' . &filetype . '_enabled_makers'
  call dko#InitList(l:maker_list)
  let l:ftfunc = 'neomake#makers#ft#' . &filetype . '#EnabledMakers'
  let {l:maker_list} = call(l:ftfunc, [])
endfunction

" ============================================================================
" ECHint
" ============================================================================

function! g:PostprocessEchint(entry) abort
  return a:entry.text =~# 'did not pass EditorConfig validation'
        \ ? extend(a:entry, { 'valid': -1 })
        \ : a:entry
endfunction

function! dko#neomake#EchintSetup() abort
  if empty(&filetype) || dko#IsNonFile(bufnr('%')) | return | endif
  let l:config = dko#project#GetFile('.editorconfig')
  if empty(l:config) | return | endif
  call dko#neomake#NpxMaker({
        \   'maker': 'echint',
        \   'errorformat': '%E%f:%l %m',
        \   'cwd': fnamemodify(l:config, ':p:h'),
        \   'postprocess': function('PostprocessEchint'),
        \ })
  let b:neomake_{&filetype}_enabled_makers += [ 'echint' ]
endfunction

" ============================================================================
" Shellcheck
" ============================================================================

function! dko#neomake#ShellcheckPosix() abort
  if &filetype !=# 'sh' | return | endif
  " https://github.com/neomake/neomake/blob/master/autoload/neomake/makers/ft/sh.vim
  let b:neomake_sh_shellcheck_args = [
        \   '--format=gcc',
        \   '--external-sources',
        \   '--shell=sh',
        \ ]
  call dko#InitDict('b:neomake_sh_enabled_makers')
  let b:neomake_sh_enabled_makers += neomake#makers#ft#sh#EnabledMakers()
endfunction

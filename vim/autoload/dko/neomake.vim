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

function! dko#neomake#CanMake(...) abort
  let l:bufnr = get(a:, 1, '%')
  return !dko#IsNonFile(l:bufnr) && !dko#IsHelp(l:bufnr)
        \ && !empty(getbufvar(l:bufnr, '&filetype'))
endfunction

" @TODO can use neomake#configure#automake() when blacklist is implemented
function! dko#neomake#MaybeRun() abort
  if !dko#neomake#CanMake('%') | return | endif
  Neomake
endfunction

" ============================================================================
" ECHint
" ============================================================================

function! g:PostprocessEchint(entry) abort
  return a:entry.text =~# 'did not pass EditorConfig validation'
        \ ? extend(a:entry, { 'valid': -1 })
        \ : a:entry
endfunction

" Excludes things like python, which has pep8.
let g:echint_whitelist = [
      \   'gitconfig',
      \   'javascript',
      \   'json',
      \   'jsx',
      \   'lua',
      \   'node',
      \   'markdown',
      \   'php',
      \   'sh',
      \   'vim',
      \   'yaml',
      \   'zsh',
      \]

function! dko#neomake#EchintCreate() abort
  let l:fts = g:echint_whitelist
  for l:ft in l:fts
    let g:neomake_{l:ft}_echint_maker = dko#neomake#NpxMaker({
          \   'maker': 'echint',
          \   'ft': l:ft,
          \   'errorformat': '%E%f:%l %m',
          \   'postprocess': function('PostprocessEchint'),
          \ }, 'global')
  endfor
endfunction

function! dko#neomake#AddMaker(ft, maker) abort
  let l:bmakers = 'b:neomake_' . a:ft . '_enabled_makers'
  if !exists(l:bmakers)
    try
      let l:makersfn = 'neomake#makers#ft#' . a:ft . '#EnabledMakers'
      let {l:bmakers} = call(l:makersfn, []) + [ a:maker ]
    catch
    endtry
  endif
endfunction

" For each filetype in the above whitelist, try to setup echint as
" a buffer-local maker, extending the current list of buffer-local makers (or
" default list)
function! dko#neomake#EchintSetup() abort
  if !dko#neomake#CanMake('%') | return | endif
  " @TODO also skip things that have automatic Neoformat enabled

  let l:safeft = neomake#utils#get_ft_confname(&filetype)
  if exists('b:did_echint_' . l:safeft) | return | endif
  let b:did_echint_{l:safeft} = 1

  let l:config = dko#project#GetFile('.editorconfig')
  if empty(l:config) | return | endif

  let l:cwd = fnamemodify(l:config, ':p:h')

  let l:fts = neomake#utils#get_config_fts(&filetype)

  let l:capable_fts = filter(l:fts, 'index(g:echint_whitelist, v:val) != -1')
  for l:ft in l:capable_fts
    if !exists('g:neomake_' . l:ft . '_echint_maker')
      continue
    endif
    let b:neomake_{l:ft}_echint_maker = copy(g:neomake_{l:ft}_echint_maker)
    let b:neomake_{l:ft}_echint_maker.cwd = l:cwd
    call dko#neomake#AddMaker(l:ft, 'echint')
  endfor
endfunction

" ============================================================================
" Shellcheck
" ============================================================================

" Assume posix
function! dko#neomake#ShellcheckPosix() abort
  if &filetype !=# 'sh' | return | endif
  " https://github.com/neomake/neomake/blob/master/autoload/neomake/makers/ft/sh.vim
  let b:neomake_sh_shellcheck_args = [
        \   '--format=gcc',
        \   '--external-sources',
        \   '--shell=sh',
        \ ]
endfunction

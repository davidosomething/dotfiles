" plugin/fzf.vim
scriptencoding utf-8
if !dko#IsPlugged('fzf.vim') | finish | endif

let g:fzf_command_prefix = 'FZF'

let g:fzf_layout = { 'down': '10' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

execute dko#MapAll({ 'key': '<F1>', 'command': 'FZFBuffers' })
execute dko#MapAll({ 'key': '<F2>', 'command': 'FZFModified' })
execute dko#MapAll({ 'key': '<F3>', 'command': 'FZFMRU' })
execute dko#MapAll({ 'key': '<F4>', 'command': 'FZFFiles' })
execute dko#MapAll({ 'key': '<F5>', 'command': 'FZFAg' })

execute dko#MapAll({ 'key': '<F8>', 'command': 'FZFColors' })

" ============================================================================
" My custom sources
" ============================================================================
"
" Notes:
" - Use fzf#wrap() instead of 'sink' option to get the <C-T/V/X> keybindings
"   when the source is to open files
"

" ansi colors even though I'm not using any right now...
" cycle through list
" multi select with <Tab>
let s:options = '--ansi --cycle --multi'

" ----------------------------------------------------------------------------
" git modified
" ----------------------------------------------------------------------------

function! s:GetFzfGitModifiedRoot()
  return exists('b:dkoproject_root')
        \ ? dkoproject#GetRoot(b:dkoproject_root)
        \ : dkoproject#GetRoot()
endfunction

function! s:GetFzfGitModifiedSource()
  let l:modified = system('git ls-files --modified --others --exclude-standard')
  let l:modified = v:shell_error ? [] : split(l:modified, '\n')
  let l:staged   = system('git diff --cached --name-only')
  let l:staged   = v:shell_error ? [] : split(l:staged, '\n')
  let l:result   = l:modified + l:staged

  return map(l:result, "fnamemodify(v:val, ':~:.')")
endfunction

" List modified, untracked, and don't include anything .gitignored
command! FZFModified call fzf#run(fzf#wrap({
      \     'source':   s:GetFzfGitModifiedSource(),
      \     'dir':      s:GetFzfGitModifiedRoot(),
      \     'options':  s:options . ' --prompt="Git[+]> "',
      \     'down':     10,
      \   }))

" ----------------------------------------------------------------------------
" My vim runtime
" ----------------------------------------------------------------------------

" @return {List} my files in my vim runtime
function! s:GetFzfVimSource()
  let l:runtime_dirs = globpath(g:dko#vim_dir, '{' . join([
        \   'after',
        \   'autoload',
        \   'ftplugin',
        \   'plugin',
        \   'snippets',
        \   'syntax',
        \ ], ',') . '}/**/*.vim', 0, 1)
  let l:runtime_files = globpath(g:dko#vim_dir, '*.vim', 0, 1)
  let l:rcfiles = globpath(g:dko#vim_dir, '*vimrc', 0, 1)
  return map( l:runtime_dirs + l:runtime_files + l:rcfiles,
        \     "fnamemodify(v:val, ':~:.')" )
endfunction

command! FZFVim
      \ call fzf#run(fzf#wrap({
      \   'source':   s:GetFzfVimSource(),
      \   'options':  s:options . ' --prompt="Vim> "',
      \   'down':     10,
      \ }))

" ----------------------------------------------------------------------------
" Whitelisted MRU/Buffer combined
" Regular MRU doesn't blacklist files
" ----------------------------------------------------------------------------

" @return {List} recently used filenames and buffers
function! s:GetFzfMruSource() abort
  return uniq(dko#GetMru() + dko#GetBuffers())
endfunction

command! FZFMRU
      \ call fzf#run(fzf#wrap({
      \   'source':  s:GetFzfMruSource(),
      \   'options': s:options . ' --no-sort --prompt="MRU> "',
      \   'down':    10,
      \ }))


" plugin/fzf.vim
scriptencoding utf-8
if !dko#IsPlugged('fzf.vim') | finish | endif

" ============================================================================
" fzf.vim Settings
" ============================================================================

if !has('nvim') && $TERM_PROGRAM ==# 'iTerm.app'
  let g:fzf_launcher = g:dko#vim_dir . '/bin/vim-fzf'
endif

let g:fzf_command_prefix = 'FZF'

let g:fzf_layout = { 'down': '10' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" ============================================================================

augroup dkofzf
  autocmd!

  " junegunn/fzf mappings for the neovim :term
  " Bind <fx> to abort FZF (<C-g> is one of the default abort keys in FZF)
  " @see #f-keys
  autocmd FileType fzf tnoremap <buffer><special> <F1> <C-g>
  autocmd FileType fzf tnoremap <buffer><special> <F2> <C-g>
  autocmd FileType fzf tnoremap <buffer><special> <F3> <C-g>
  autocmd FileType fzf tnoremap <buffer><special> <F4> <C-g>
  autocmd FileType fzf tnoremap <buffer><special> <F8> <C-g>
augroup END

" ============================================================================
" Custom commands for fzf.vim
" ============================================================================

" fzf.vim ripgrep or ag with preview
" @see https://github.com/junegunn/fzf.vim#advanced-customization
if dko#GetGrepper().command ==# 'rg'
  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#grep(
        \   'rg --column --line-number --no-heading --color=always '
        \     . shellescape(<q-args>),
        \   1,
        \   <bang>0
        \     ? fzf#vim#with_preview('up:60%')
        \     : fzf#vim#with_preview('right:50%:hidden', '?'),
        \   <bang>0
        \ )
elseif dko#GetGrepper().command ==# 'ag'
  command! -bang -nargs=*
        \ FZFGrepper
        \ call fzf#vim#ag(
        \   <q-args>,
        \   <bang>0
        \     ? fzf#vim#with_preview('up:60%')
        \     : fzf#vim#with_preview('right:50%:hidden', '?'),
        \   <bang>0
        \ )
endif

" ============================================================================
" Custom sources for junegunn/fzf
" ============================================================================

" Notes:
" - Use fzf#wrap() instead of 'sink' option to get the <C-T/V/X> keybindings
"   when the source is to open files
"

" Some default options. Removed --ansi for now, not using it
" cycle through list
" multi select with <Tab>
let s:options = ' --cycle --multi '

" ----------------------------------------------------------------------------
" git modified
" ----------------------------------------------------------------------------

" @return {String} project root
function! s:GetFzfGitModifiedRoot() abort
  return exists('b:dkoproject_root')
        \ ? dkoproject#GetRoot(b:dkoproject_root)
        \ : dkoproject#GetRoot()
endfunction

" Depends on my `git-modified` script, see:
" https://github.com/davidosomething/dotfiles/blob/master/bin/git-modified
"
" @param {String[]} args passed to git-modified, e.g. `--branch somebranch`
" @return {String[]} list of shortened filepaths that are modified or staged
function! s:GetFzfGitModifiedSource(...) abort
  let l:args = get(a:, '000', [])
  let l:modified = system('git modified ' . join(l:args, ' '))
  if v:shell_error
    return []
  endif
  return split(l:modified, '\n')
endfunction

" List modified, untracked, and don't include anything .gitignored
" Accepts args for `git-modified`
command! -nargs=* FZFModified call fzf#run(fzf#wrap('GitModified', {
      \   'source':   s:GetFzfGitModifiedSource(<f-args>),
      \   'dir':      s:GetFzfGitModifiedRoot(),
      \   'options':  s:options . ' --prompt="Dirty> "',
      \   'down':     10,
      \ }))

" ----------------------------------------------------------------------------
" My vim runtime
" ----------------------------------------------------------------------------

" @return {List} my files in my vim runtime
function! s:GetFzfVimSource() abort
  " Want these recomputed every time in case files are added/removed
  let l:runtime_dirs_files = globpath(g:dko#vim_dir, '{' . join([
        \   'after',
        \   'autoload',
        \   'ftplugin',
        \   'plugin',
        \   'snippets',
        \   'syntax',
        \ ], ',') . '}/**/*.vim', 0, 1)
  let l:runtime_files = globpath(g:dko#vim_dir, '*.vim', 0, 1)
  let l:rcfiles = globpath(g:dko#vim_dir, '*vimrc', 0, 1)
  return dko#ShortPaths( l:runtime_dirs_files + l:runtime_files + l:rcfiles )
endfunction

command! FZFVim
      \ call fzf#run(fzf#wrap('Vim', {
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
      \ call fzf#run(fzf#wrap('MRU', {
      \   'source':  s:GetFzfMruSource(),
      \   'options': s:options . ' --no-sort --prompt="MRU> "',
      \   'down':    10,
      \ }))

" ============================================================================
" Mappings
" ============================================================================

execute dko#MapAll({ 'key': '<F1>', 'command': 'FZFGrepper!' })
execute dko#MapAll({ 'key': '<F2>', 'command': 'FZFModified' })
execute dko#MapAll({ 'key': '<F3>', 'command': 'FZFMRU' })
execute dko#MapAll({ 'key': '<F4>', 'command': 'FZFFiles' })
execute dko#MapAll({ 'key': '<F8>', 'command': 'FZFColors!' })


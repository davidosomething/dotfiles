" plugin/fzf.vim
scriptencoding utf-8
if !dko#IsPlugged('fzf.vim') | finish | endif

" ============================================================================
" fzf.vim Settings
" ============================================================================

" iTerm can pipe from a spawned FZF back to Vim
if !has('nvim') && $TERM_PROGRAM ==# 'iTerm.app'
  let g:fzf_launcher = g:dko#vim_dir . '/bin/vim-fzf'
endif

let g:fzf_command_prefix = 'FZF'

let g:fzf_layout = { 'down': 16 }

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
" Local Helpers
" ============================================================================

" fzf#run() can't use autoload function in options so wrap it with
" a script-local
"
" @return {String} project root
function! s:GetRoot() abort
  return dkoproject#GetRoot()
endfunction

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
" git relevant
" ----------------------------------------------------------------------------

" Depends on my `git-relevant` script, see:
" https://github.com/davidosomething/dotfiles/blob/master/bin/git-relevant
"
" @param {String[]} args passed to git-relevant, e.g. `--branch somebranch`
" @return {String[]} list of shortfilepaths that are relevant to the branch
function! s:GetFzfRelevantSource(...) abort
  let l:args = get(a:, '000', [])
  let l:relevant = system(
        \   'cd "' . s:GetRoot() . '" '
        \ . '&& git relevant ' . join(l:args, ' ')
        \)
  if v:shell_error
    return []
  endif

  " List of paths, relative to the buffer's b:dkoproject_root
  let l:relevant_list = split(l:relevant, '\n')

  " Check that the paths, prefixed with the root exist
  let l:filtered = filter(l:relevant_list,
        \ 'filereadable(expand("' . s:GetRoot() . '/" . v:val))'
        \ )
  return l:filtered
endfunction

" List relevant and don't include anything .gitignored
" Accepts args for `git-relevant`
command! -nargs=* FZFRelevant call fzf#run(fzf#wrap('Relevant',
      \   fzf#vim#with_preview(extend({
      \     'source':   s:GetFzfRelevantSource(<f-args>),
      \     'dir':      s:GetRoot(),
      \     'options':  s:options . ' --prompt="Relevant> "',
      \   }, g:fzf_layout), 'right:50%')
      \ ))

" ----------------------------------------------------------------------------
" My vim runtime files
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
      \ call fzf#run(fzf#wrap('Vim',
      \   extend({
      \     'source':   s:GetFzfVimSource(),
      \     'options':  s:options . ' --prompt="Vim> "',
      \   }, g:fzf_layout)
      \ ))

" ----------------------------------------------------------------------------
" Whitelisted MRU/Buffer combined.
" Regular :FZFHistory doesn't blacklist files
" ----------------------------------------------------------------------------

" @return {List} recently used filenames and buffers
function! s:GetFzfMruSource() abort
  return uniq(dko#GetMru() + dko#GetBuffers())
endfunction

command! FZFMRU
      \ call fzf#run(fzf#wrap('MRU',
      \   fzf#vim#with_preview(extend({
      \     'source':  s:GetFzfMruSource(),
      \     'options': s:options . ' --no-sort --prompt="MRU> "',
      \   }, g:fzf_layout), 'right:50%')
      \ ))

" ============================================================================
" Custom commands for fzf.vim
" ============================================================================

" fzf.vim ripgrep or ag with preview (requires ruby, but safely checks for it)
" Fallback to git-grep if rg and ag not installed (e.g. I'm ssh'ed somewhere)
" @see https://github.com/junegunn/fzf.vim#advanced-customization
"
" Always grep from the project root, not from CWD
let s:grepper_fzf_options = {
      \   'dir': s:GetRoot(),
      \ }

" FZFGrepper! settings
let s:grepper_full = fzf#vim#with_preview(
      \   s:grepper_fzf_options,
      \   'up:60%'
      \ )

" FZFGrepper settings
let s:grepper_half = fzf#vim#with_preview(
      \   s:grepper_fzf_options,
      \   'right:50%:hidden',
      \   '?'
      \ )

if dko#GetGrepper().command ==# 'ag'
  " @see https://github.com/junegunn/fzf.vim/blob/abdf894edf5dbbe8eaa734a6a4dce39c9f174e33/autoload/fzf/vim.vim#L614
  " Default options are --nogroup --column --color
  let s:ag_options = ' --one-device --skip-vcs-ignores --smart-case '

  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#ag(
        \   <q-args>,
        \   s:ag_options,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
elseif dko#GetGrepper().command ==# 'rg'
  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#grep(
        \   'rg --color=always --column --hidden --line-number --no-heading '
        \     . '--no-ignore-vcs '
        \     . '--ignore-file "${DOTFILES}/ag/dot.ignore" '
        \     . shellescape(<q-args>),
        \   1,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
else
  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#grep(
        \   'git grep --line-number ' . shellescape(<q-args>),
        \   1,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
endif

" ============================================================================
" Mappings
" ============================================================================

execute dko#MapAll({ 'key': '<F1>', 'command': 'FZFGrepper!' })
execute dko#MapAll({ 'key': '<F2>', 'command': 'FZFRelevant' })
execute dko#MapAll({ 'key': '<F3>', 'command': 'FZFMRU' })
execute dko#MapAll({ 'key': '<F4>', 'command': 'FZFFiles' })
execute dko#MapAll({ 'key': '<F8>', 'command': 'FZFColors!' })


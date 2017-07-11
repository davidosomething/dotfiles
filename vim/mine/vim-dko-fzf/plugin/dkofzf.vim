" plugin/fzf.vim
scriptencoding utf-8

if !dko#IsLoaded('fzf.vim') | finish | endif

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

" @return {String} test specs dir
function! s:GetSpecs() abort
  return dkoproject#GetDir('tests')
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
" Alternatively use git-extras' `git-delta` (though it doesn't get unstaged
" files)
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
      \     'dir':      s:GetRoot(),
      \     'source':   s:GetFzfRelevantSource(<f-args>),
      \     'options':  s:options . ' --prompt="Rel> "',
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
        \   'mine',
        \   'plugin',
        \   'snippets',
        \   'syntax',
        \ ], ',') . '}/**/*.vim', 0, 1)
  let l:runtime_files = globpath(g:dko#vim_dir, '*.vim', 0, 1)
  let l:rcfiles = globpath(g:dko#vim_dir, '*vimrc', 0, 1)
  return l:runtime_dirs_files + l:runtime_files + l:rcfiles
endfunction

command! FZFVim
      \ call fzf#run(fzf#wrap('Vim',
      \   fzf#vim#with_preview(extend({
      \     'dir':      s:GetRoot(),
      \     'source':   s:GetFzfVimSource(),
      \     'options':  s:options . ' --prompt="Vim> "',
      \   }, g:fzf_layout), 'right:50%')
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

" ----------------------------------------------------------------------------
" Test specs
" ----------------------------------------------------------------------------

" @return {List} test spec files
function! s:GetFzfSpecsSource() abort
  let l:tests_dirs = join(filter([
        \   dkoproject#GetDir('tests'),
        \   dkoproject#GetDir('specs'),
        \ ], "v:val !=# ''"), ',')
  echom l:tests_dirs
  let l:dir_files = empty(l:tests_dirs)
        \ ? []
        \ : globpath(l:tests_dirs, '**/*.*', 0, 1)
  let l:local_files = globpath(expand('%:p:h'), '*.test.*', 0, 1)
  let l:glob = l:dir_files + l:local_files
  let l:filtered = filter(l:glob, "v:val !~# 'node_modules'")
  return dko#ShortPaths(l:filtered)
endfunction

command! FZFSpecs
      \ call fzf#run(fzf#wrap('Specs',
      \   fzf#vim#with_preview(extend({
      \     'dir':      s:GetRoot(),
      \     'source':   s:GetFzfSpecsSource(),
      \     'options':  s:options . ' --prompt="Specs> "',
      \   }, g:fzf_layout), 'right:50%')
      \ ))

" ============================================================================
" Custom commands for fzf.vim
" ============================================================================

" ----------------------------------------------------------------------------
" FZFGrepper
" fzf.vim ripgrep or ag with preview (requires ruby, but safely checks for it)
" Fallback to git-grep if rg and ag not installed (e.g. I'm ssh'ed somewhere)
" @see https://github.com/junegunn/fzf.vim#advanced-customization
" ----------------------------------------------------------------------------

" FZFGrepper! settings
let s:grepper_full = fzf#vim#with_preview(
      \   { 'dir': s:GetRoot() },
      \   'up:60%'
      \ )

" FZFGrepper settings
let s:grepper_half = fzf#vim#with_preview(
      \   { 'dir': s:GetRoot() },
      \   'right:50%',
      \   '?'
      \ )

if dko#GetGrepper().command ==# 'rg'
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
elseif dko#GetGrepper().command ==# 'ag'
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
else
  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#grep(
        \   'git grep --line-number ' . shellescape(<q-args>),
        \   1,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
endif

" ----------------------------------------------------------------------------
" Files from project root
" ----------------------------------------------------------------------------

" FZFProject! settings
let s:project_full = fzf#vim#with_preview(
      \   {},
      \   'up:60%'
      \ )

" FZFProject settings
let s:project_half = fzf#vim#with_preview(
      \   {},
      \   'right:50%',
      \   '?'
      \ )

command! -bang FZFProject
      \ call fzf#vim#files(
      \   s:GetRoot(),
      \   <bang>0 ? s:project_full : s:project_half,
      \   <bang>0
      \ )

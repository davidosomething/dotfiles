" plugin/unite.vim
scriptencoding utf-8
if !exists("g:plugs['unite.vim']") | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

augroup dkounite
  autocmd!
augroup END

" ============================================================================
" Extension: neomru settings
" ============================================================================

if exists("g:plugs['neomru.vim']")
  let g:neomru#update_interval      = 300     " Update cache every 5 minutes
  let g:neomru#file_mru_limit       = 200     " Fewer files in mru
  let g:neomru#directory_mru_limit  = 0       " Don't list directories
endif

" ============================================================================
" unite settings
" ============================================================================

" candidates
let g:unite_source_grep_max_candidates = 300

" use ag for file_rec/async and unite grep
if executable('ag')
  let s:ag_opts = ' -i --vimgrep --hidden'

  " Ignore wildignores too
  " https://github.com/gf3/dotfiles/blob/master/.vimrc#L564
  for s:i in split(&wildignore, ',')
    let s:i = substitute(s:i, '\*/\(.*\)/\*', '\1', 'g')
    let s:ag_opts = s:ag_opts .
          \ ' --ignore "' . substitute(s:i, '\*/\(.*\)/\*', '\1', 'g') . '"'
  endfor

  " This setting reverted so just providing --vimgrep no longer works
  " https://github.com/Shougo/unite.vim/issues/986#issuecomment-133950231
  let g:unite_source_rec_async_command  = [ 'ag',
        \ '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '' ]

  let g:unite_source_grep_command       = 'ag'
  let g:unite_source_grep_default_opts  = s:ag_opts
  let g:unite_source_grep_recursive_opt = ''
endif

" ============================================================================
" unite profiles
" ============================================================================

function! s:UniteProfiles()

  " ----------------------------------------------------------------------
  " Default matcher settings
  " ----------------------------------------------------------------------

  " Always fuzzy (e.g. abc matches app/book/collection)
  call unite#filters#matcher_default#use([
        \   'matcher_fuzzy',
        \   'matcher_hide_current_file',
        \ ])

  " ----------------------------------------------------------------------
  " Default sorter settings
  " ----------------------------------------------------------------------

  " Rank matches (slower) but more accurate finding
  let s:default_sorter = has('python') || has('python3')
        \ ? 'sorter_selecta'
        \ : 'sorter_rank'
  call unite#filters#sorter_default#use(s:default_sorter)

  " ----------------------------------------------------------------------
  " File source settings
  " ----------------------------------------------------------------------

  " In file search, display relative paths (since we do UniteWithProjectDir)
  " https://github.com/Shougo/unite.vim/blob/master/autoload/unite/filters/converter_relative_word.vim
  call unite#custom#source(
        \   'file_rec,file_rec/async,file_rec/neovim',
        \   'converters',
        \   ['converter_relative_word']
        \ )

  " ----------------------------------------------------------------------
  " Split profile: default - open in bottom pane like ctrl-p
  " ----------------------------------------------------------------------

  call unite#custom#profile('default', 'context', {
        \   'direction':          'botright',
        \   'max_candidates':     300,
        \   'no_empty':           1,
        \   'prompt':             '» ',
        \   'short_source_names': 1,
        \   'silent':             1,
        \   'toggle':             1,
        \   'winheight':          12,
        \ })

  " ----------------------------------------------------------------------
  " Split profile: unite-outline - open in right pane like tagbar
  " ----------------------------------------------------------------------

  call unite#custom#profile('source/outline', 'context', {
        \   'auto-highlight':     '1',
        \   'direction':          'botright',
        \   'no_empty':           1,
        \   'prompt_direction':   'top',
        \   'toggle':             1,
        \   'vertical':           1,
        \   'winwidth':           48,
        \ })

endfunction

autocmd dkounite VimEnter * call s:UniteProfiles()

" ============================================================================
" Unite buffer keybindings
" ============================================================================

function! s:BindUniteBufferKeys()
  " also exit with function keys, so you can toggle with same key
  for l:fnum in range(1, 12)
    let l:fk = '<F' . l:fnum . '>'
    execute 'imap <buffer><special> ' . l:fk . ' '
          \ . '<Plug>(unite_insert_leave)'
          \ . '<Plug>(unite_cursor_bottom)'
          \ . '<Plug>(unite_all_exit)'
    execute 'nmap <buffer><special> ' . l:fk . ' <Plug>(unite_all_exit)'
  endfor

  " never use unite actions on TAB
  unmap   <buffer><special>  <Tab>
  iunmap  <buffer><special>  <Tab>
endfunction

autocmd dkounite FileType unite call s:BindUniteBufferKeys()

" ============================================================================
" Global keys to open unite
" ============================================================================

function! s:BindFunctionKeys()
  if exists("g:plugs['unite-outline']")
    execute dko#BindFunction('<F2>', 'Unite outline')
  endif
  execute dko#BindFunction('<F3>', 'Unite -start-insert buffer')
  if exists("g:plugs['neomru.vim']")
    execute dko#BindFunction('<F4>', 'Unite -start-insert neomru/file')
  endif
  if has('nvim')
    execute dko#BindFunction('<F5>', 'Unite -start-insert file_rec/neovim:!')
  else
    execute dko#BindFunction('<F5>', 'Unite -start-insert file_rec/async:!')
  endif
  execute dko#BindFunction('<F6>', 'UniteWithProjectDir grep:.')
  if exists("g:plugs['unite-tag']")
    execute dko#BindFunction('<F7>', 'Unite -start-insert tag')
  endif
  execute dko#BindFunction('<F8>', 'Unite -start-insert command')
endfunction

autocmd dkounite VimEnter * call s:BindFunctionKeys()

let s:cpo_save = &cpoptions
set cpoptions&vim


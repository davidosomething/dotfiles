" plugin/unite.vim
scriptencoding utf-8

if !dko#IsPlugged('unite.vim') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

augroup dkounite
  autocmd!
augroup END

" ============================================================================
" Extension: neomru settings
" ============================================================================

let g:neomru#update_interval      = 300     " Update cache every 5 minutes
let g:neomru#file_mru_limit       = 100     " Fewer files in mru
let g:neomru#directory_mru_limit  = 0       " Don't list directories

" ============================================================================
" unite settings
" ============================================================================

let g:unite_source_grep_max_candidates = 300
let g:unite_source_grep_recursive_opt = ''

if !empty(dko#GetGrepper())
  let g:unite_source_grep_command = dko#GetGrepper().command
  let g:unite_source_grep_default_opts = join(dko#GetGrepper().options, ' ')
  let g:unite_source_rec_async_command =
        \ [ dko#GetGrepper().command ] + dko#GetGrepper().options
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
  " Unite window profile: default - open in bottom pane like ctrl-p
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
  " Unite window profile: unite-outline - open in right pane like tagbar
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
    execute 'silent! iunmap <buffer><special> ' . l:fk
    execute 'silent! unmap <buffer><special> ' . l:fk

    execute 'imap <buffer><special> ' . l:fk . ' '
          \ . '<Plug>(unite_insert_leave)'
          \ . '<Plug>(unite_cursor_bottom)'
          \ . '<Plug>(unite_all_exit)'
    execute 'nmap <buffer><special> ' . l:fk . ' <Plug>(unite_all_exit)'
  endfor

  imap    <buffer><special>  <C-j>   <Plug>(unite_select_next_line)
  imap    <buffer><special>  <C-d>   <Plug>(unite_select_next_page)
  imap    <buffer><special>  <C-k>   <Plug>(unite_select_previous_line)
  imap    <buffer><special>  <C-u>   <Plug>(unite_select_previous_page)

  imap    <silent><buffer><expr>  <C-s>     unite#do_action('split')
  imap    <silent><buffer><expr>  <C-v>     unite#do_action('vsplit')
  imap    <silent><buffer><expr>  <C-t>     unite#do_action('tabopen')

  " never use unite actions on TAB
  iunmap  <buffer><special>  <Tab>
  unmap   <buffer><special>  <Tab>
endfunction

autocmd dkounite FileType unite call s:BindUniteBufferKeys()

" ============================================================================
" Global keys to open unite
" ============================================================================

function! s:BindFunctionKeys()
  if dko#IsPlugged('unite-outline')
    execute dko#MapAll({
          \   'key':      '<F2>',
          \   'command':  'Unite outline',
          \ })
  endif

  " Using :FZB instead of Unite for buffer list
  if !g:dko_use_fzf
    execute dko#MapAll({
          \   'key':      '<F3>',
          \   'command':  'Unite -start-insert buffer',
          \ })
  endif

  if dko#IsPlugged('neomru.vim')
    execute dko#MapAll({
          \   'key':     '<F4>',
          \   'command': 'Unite -start-insert neomru/file',
          \ })
  endif

  " Using :FZF instead of Unite for file reducing
  if !g:dko_use_fzf
    if has('nvim')
      execute dko#MapAll({
            \   'key':      '<F5>',
            \   'command':  'Unite -start-insert file_rec/neovim:!',
            \ })
    else
      execute dko#MapAll({
            \   'key':      '<F5>',
            \   'command':  'Unite -start-insert file_rec/async:!',
            \ })
    endif
  endif

  execute dko#MapAll({
        \   'key':      '<F6>',
        \   'command':  'UniteWithProjectDir grep:. -wrap',
        \ })

  if dko#IsPlugged('unite-tag')
    execute dko#MapAll({
          \   'key':      '<F7>',
          \   'command':  'Unite -start-insert tag',
          \ })
  endif

  execute dko#MapAll({
        \   'key':    '<F8>',
        \   'command': 'Unite -start-insert command',
        \ })
endfunction

autocmd dkounite VimEnter * call s:BindFunctionKeys()

let s:cpo_save = &cpoptions
set cpoptions&vim


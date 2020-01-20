" autoload/dko/grepper.vim

let s:ignore = expand($DOTFILES) . '/' . 'ag/dot.ignore'

" Cached
function! dko#grepper#Get() abort
  if exists('s:grepper') | return s:grepper | endif

  let l:greppers = {}
  let l:greppers.rg = {
        \   'command': 'rg',
        \   'options': [
        \     '--hidden',
        \     '--ignore-file ' . s:ignore,
        \     '--smart-case',
        \     '--vimgrep',
        \   ],
        \   'format': '%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m',
        \ }
  let l:greppers.ag = {
        \   'command': 'ag',
        \   'options': [
        \     '--hidden',
        \     '--path-to-ignore ' . s:ignore,
        \     '--smart-case',
        \     '--vimgrep',
        \   ],
        \   'format': '%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m',
        \ }
  let l:greppers.ack = {
        \   'command': 'ack',
        \   'options': [
        \     '--nogroup',
        \     '--nocolor',
        \     '--smart-case',
        \     '--column',
        \   ],
        \   'format': '%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f %l%m',
        \ }

  let l:grepper_name =
        \   executable('rg') ? 'rg'
        \ : executable('ag') ? 'ag'
        \ : executable('ack') ? 'ack'
        \ : ''

  let s:grepper = empty(l:grepper_name)
        \ ? { 'command': '' }
        \ : l:greppers[l:grepper_name]

  return s:grepper
endfunction

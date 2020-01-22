scriptencoding utf-8
" autoload/dko/float.vim

let s:DEFAULT_HEIGHT_RATIO = 0.8
let s:DEFAULT_WIDTH_RATIO = 0.8
function! dko#float#GetOptions(params) abort
  let l:opts = {}
  let l:opts.relative = 'editor'
  let l:opts.style = 'minimal'

  " size
  let l:ratio_height = float2nr(&lines * s:DEFAULT_HEIGHT_RATIO)
  let l:max_height = &lines - 20
  let l:opts.height = max([
        \   l:ratio_height,
        \   l:max_height,
        \   1,
        \ ])
  let l:ratio_width = float2nr(&columns * s:DEFAULT_WIDTH_RATIO)
  let l:max_width = &columns - 20
  let l:opts.width = max([
        \   l:ratio_width,
        \   l:max_width,
        \   1,
        \ ])

  " centered
  let l:opts.row = float2nr((&lines - l:opts.height) / 2)
  let l:opts.col = float2nr((&columns - l:opts.width) / 2)

  return extend(l:opts, a:params)
endfunction

" Adapted from https://github.com/junegunn/fzf.vim/issues/664
function! dko#float#Open(hl, params) abort
  let l:buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')
  let l:opts = dko#float#GetOptions(a:params)
  let l:win = nvim_open_win(l:buf, v:true, l:opts)
  call setwinvar(l:win, '&winhighlight', 'NormalFloat:' . a:hl)
  call setwinvar(l:win, '&colorcolumn', '')
  return { 'buf': l:buf, 'win': l:win }
endfunction

function! dko#float#Bordered() abort
  let l:opts = dko#float#GetOptions({})
  let l:top = '╭' . repeat('─', l:opts.width - 2) . '╮'
  let l:mid = '│' . repeat(' ', l:opts.width - 2) . '│'
  let l:bot = '╰' . repeat('─', l:opts.width - 2) . '╯'
  let l:border = [l:top] + repeat([l:mid], l:opts.height - 2) + [l:bot]

  " Draw frame
  let g:frame = dko#float#Open('Ignore', {
        \   'row': l:opts.row,
        \   'col': l:opts.col,
        \   'width': l:opts.width,
        \   'height': l:opts.height
        \ })
  call nvim_buf_set_lines(g:frame.buf, 0, -1, v:true, l:border)

  " Draw viewport
  let s:viewport = dko#float#Open('Normal', {
        \   'row': l:opts.row + 1,
        \   'col': l:opts.col + 2,
        \   'width': l:opts.width - 4,
        \   'height': l:opts.height - 2
        \ })

  " Close border float when viewport float closes
  augroup dkofloat
    autocmd!
    autocmd BufWipeout <buffer> execute 'bwipeout' g:frame.buf
  augroup END
endfunction

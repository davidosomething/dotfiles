" plugin/fzf.vim
scriptencoding utf-8

if !g:dko_use_fzf | finish | endif

" ============================================================================
" :FZB to list buffers
" ============================================================================

function! s:GetBufferList() abort
  redir => l:ls
  silent ls
  redir END
  return split(l:ls, '\n')
endfunction

function! s:OpenBuffer(e) abort
  execute 'buffer ' . matchstr(a:e, '^[ 0-9]*')
endfunction

command! FZB
      \ call fzf#run({
      \   'source':  reverse(s:GetBufferList()),
      \   'sink':    function('s:OpenBuffer'),
      \   'options': '+m',
      \   'down':    min([ len(s:GetBufferList()) + 2, 10 ]),
      \ })
execute dko#MapAll({ 'key': '<F1>', 'command': 'FZB' })

" ============================================================================
" :FZM for open buffers AND MRU
" ============================================================================

let s:mru_filter = join([
      \   'Bufferize:',
      \   'fugitive:',
      \   '\[unite\]',
      \   'NERD_tree',
      \   '^/tmp/',
      \   '.git/',
      \   'nvim/runtime/doc/',
      \ ], '\|')
      \ 
function! s:GetMruFiles() abort
  return extend(
  \ filter(copy(v:oldfiles),
  \        "v:val !~? '" . s:mru_filter . "'"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

command! FZM
      \ call fzf#run({
      \   'source':  reverse(s:GetMruFiles()),
      \   'sink':    'edit',
      \   'options': '-m -x +s',
      \   'down':    min([ len(s:GetMruFiles()) + 2, 10 ]),
      \ })
execute dko#MapAll({ 'key': '<F2>', 'command': 'FZM' })

" ============================================================================
" Use FZF to search files
" ============================================================================

execute dko#MapAll({ 'key': '<F3>', 'command': 'FZF' })

" ============================================================================
" :FZC to switch color scheme
" ============================================================================

command! FZC
      \ call fzf#run({
      \   'source':
      \     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
      \         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
      \   'sink':    'colo',
      \   'options': '+m',
      \   'down':    10,
      \ })
execute dko#MapAll({ 'key': '<F8>', 'command': 'FZC' })


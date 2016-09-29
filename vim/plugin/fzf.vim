" plugin/fzf.vim
scriptencoding utf-8

if !g:dko_use_fzf | finish | endif

" ============================================================================
" Use FZF to search files
" ============================================================================
execute dko#BindFunction('<F5>', 'FZF')

" ============================================================================
" :FZC to switch color scheme
" ============================================================================

command! FZC call fzf#run({
      \   'source':
      \     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
      \         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
      \   'sink':    'colo',
      \   'options': '+m',
      \   'down':    10,
      \ })

" ============================================================================
" :FZB to list buffers, bound to F3
" ============================================================================

function! s:GetBufferList()
  redir => l:ls
  silent ls
  redir END
  return split(l:ls, '\n')
endfunction

function! s:OpenBuffer(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

command! FZB call fzf#run({
      \   'source':  reverse(<SID>GetBufferList()),
      \   'sink':    function('<SID>OpenBuffer'),
      \   'options': '+m',
      \   'down':    min([ len(<SID>GetBufferList()) + 2, 10 ]),
      \ })
execute dko#BindFunction('<F3>', 'FZB')

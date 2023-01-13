" after/ftplugin/php.vim

if exists('b:did_after_ftplugin') | finish | endif
let b:did_after_ftplugin = 1

setlocal omnifunc=

setlocal iskeyword+=$

" ============================================================================
" Unmap terrible mappings from $VIMRUNTIME/ftplugin/php.vim
" ============================================================================

silent! nunmap <buffer> [[
silent! nunmap <buffer> ]]
silent! ounmap <buffer> [[
silent! ounmap <buffer> ]]

" Remap them with my own
let s:match_done = '<CR>:nohlsearch<CR>'
let s:matches = '\('
      \.  '<?php'
      \.  '\|' . '\('
      \.    '\(abstract\s\|final\s\)\=' . '\('
      \.      'class\s'
      \.      '\|' . '\('
      \.        'private\s\|protected\s\|public\s\|static\s'
      \.      '\)\=' . 'function\s'
      \.    '\)'
      \.  '\)'
      \.  '\|' . 'interface '
      \. '\)'
execute 'nmap <silent><buffer> [[ ?' . escape(s:matches, '|?') . s:match_done
execute 'omap <silent><buffer> [[ ?' . escape(s:matches, '|?') . s:match_done
execute 'nmap <silent><buffer> ]] /' . escape(s:matches, '|') . s:match_done
execute 'omap <silent><buffer> ]] /' . escape(s:matches, '|') . s:match_done

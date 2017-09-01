" after/ftplugin/php.vim

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

" ============================================================================
" EditorConfig overrides
" ============================================================================

if dko#IsLoaded('editorconfig-vim')
  function! DKO_EditorConfigPhp(config) abort
    setlocal softtabstop=-2
    return 0
  endfunction

  call editorconfig#AddNewHook(function('DKO_EditorConfigPhp'))
endif

" ============================================================================
" StanAngeloff/php.vim
" ============================================================================

if dko#IsPlugged('php.vim')
  " Syntax highlighting in phpdoc blocks
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endif


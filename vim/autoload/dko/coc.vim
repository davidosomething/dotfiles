function! dko#coc#InstallExtensions() abort
  let s:extensions = [
        \  'coc-css',
        \  'coc-eslint',
        \  'coc-highlight',
        \  'coc-json',
        \  'coc-neosnippet',
        \  'coc-snippets',
        \  'coc-tsserver',
        \  'coc-vimlsp',
        \  'coc-yaml',
        \]
  for l:ext in s:extensions
    if !(finddir(l:ext, coc#util#extension_root()))
      call coc#util#install_extension(['-sync', l:ext])
    endif
  endfor
endfunction

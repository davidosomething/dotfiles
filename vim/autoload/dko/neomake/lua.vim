" autoload/dko/neomake/lua.vim

function! dko#neomake#lua#Setup() abort
  let l:safeft = neomake#utils#get_ft_confname(&filetype)
  if exists('b:did_dkoneomake_' . l:safeft) | return | endif
  let b:did_dkoneomake_{l:safeft} = 1

  let b:neomake_lua_luacheck_args = [
        \   '--no-color',
        \   '--formatter', 'plain',
        \   '--ranges',
        \   '--codes',
        \ ]
endfunction

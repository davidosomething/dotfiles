" autoload/dko/neomake/lua.vim

function! dko#neomake#lua#Setup() abort
  let l:safeft = neomake#utils#get_ft_confname(&filetype)
  if exists('b:did_dkoneomake_' . l:safeft) | return | endif
  let b:did_dkoneomake_{l:safeft} = 1

  let l:config = dko#project#GetFile('.luacheckrc')
  let l:cwd = fnamemodify(l:config, ':p:h')
  let b:neomake_lua_luacheck_cwd = l:cwd
  let b:neomake_lua_luacheck_args = [
        \   '--no-color',
        \   '--formatter', 'plain',
        \   '--ranges',
        \   '--codes',
        \ ]
endfunction

" ftplugin/lua.vim

call dko#TwoSpace()
setlocal nowrap

setlocal comments-=:-- comments+=:---,:--

let &l:makeprg = 'luacheck '
      \. '--no-color '
      \. '--formatter plain '
      \. '--ranges '
      \. '--codes '

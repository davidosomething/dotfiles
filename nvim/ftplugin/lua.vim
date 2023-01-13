" ftplugin/lua.vim

call dko#TwoSpace()
setlocal nowrap

setlocal comments-=:-- comments+=:---,:--

let &l:makeprg = 'cd %:p:h && luacheck '
      \. '--no-color '
      \. '--formatter plain '
      \. '--ranges '
      \. '--codes '
      \. '%'

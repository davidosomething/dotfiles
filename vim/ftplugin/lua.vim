" ftplugin/lua.vim

call dko#TwoSpace()
setlocal nowrap

let &l:makeprg = 'luacheck '
      \. '--no-color '
      \. '--formatter plain '
      \. '--ranges '
      \. '--codes '

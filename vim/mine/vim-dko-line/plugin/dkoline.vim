" plugin/dkoline.vim

augroup dkoline-plugin
  autocmd!
  autocmd VimEnter * call dkoline#Init()
augroup END

let s:refresh_hooks = [
      \   'BufWinEnter',
      \   'FileType',
      \   'FileWritePost',
      \   'SessionLoadPost',
      \   'WinEnter',
      \   'CursorMoved',
      \ ]
" CursorMoved is for updating anzu search status accurately

let s:user_refresh_hooks = [
      \   'GutentagsUpdated',
      \ ]
" 'NeomakeCountsChanged',
" 'NeomakeFinished'

execute 'autocmd dkoline-plugin ' . join(s:refresh_hooks, ',') . ' * call dkoline#Refresh()'
execute 'autocmd dkoline-plugin User ' . join(s:user_refresh_hooks, ',') . ' call dkoline#Refresh()'

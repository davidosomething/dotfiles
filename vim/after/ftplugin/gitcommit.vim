" gitcommit
"
" Nice big git commit message window
" Only runs in a vim server named GIT (probably opened via my "e" script)
"

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

if v:servername == "GIT"
  if has('gui_running')
    setlocal lines=44 columns=88
    setlocal nonumber
    if has('gui_macvim')
      setlocal guifont=Fira\ Mono\ for\ Powerline:h10
    else
      setlocal guifont=Fira\ Mono\ for\ Powerline\ 10
    endif
  endif

  " augroup gitmerge
  "   autocmd!
  " augroup END

  augroup gitcommit
    autocmd!
    au BufNewFile,BufRead *.git/{,modules/**/}{COMMIT_EDIT,TAG_EDIT,}MSG
          \ startinsert
  augroup END
endif


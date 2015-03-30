" gitcommit
"
" Nice big git commit message window
" Only runs in a vim server named GIT (probably opened via my "e" script)
"

if v:servername == "GIT"
  if has('gui_running')
    set lines=24 columns=88
    if has('gui_macvim')
      set guifont=Fira\ Mono\ for\ Powerline:h14

    else
      set guifont=Fira\ Mono\ for\ Powerline\ 14

    endif
  endif

  startinsert
endif


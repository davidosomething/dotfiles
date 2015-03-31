" gitcommit
"
" Nice big git commit message window
" Only runs in a vim server named GIT (probably opened via my "e" script)
"

if v:servername == "GIT"
  if has('gui_running')
    set lines=44 columns=88
    set nonumber
    if has('gui_macvim')
      set guifont=Fira\ Mono\ for\ Powerline:h10

    else
      set guifont=Fira\ Mono\ for\ Powerline\ 10

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


" gitcommit
"
" Nice big git commit message window
" Only runs in a vim server named GIT (probably opened via my "e" script)
"

setlocal spell
setlocal wrap
setlocal linebreak

" override settings that were undone by @gtd in tpope/vim-git
setlocal textwidth=80
setlocal tabstop=4
setlocal formatoptions+=croq

" ============================================================================
" vopen + committia mode
" ============================================================================

if v:servername == "GIT"
  if has('gui_running')
    " Non-local -- for the entire GIT clientserver
    set lines=44 columns=88
    set nonumber
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


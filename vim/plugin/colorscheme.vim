" plugin/colorscheme.vim

if g:truecolor
  let &termguicolors = 1

  if dkoplug#Exists('vim-two-firewatch')
    function! s:Firewatch() abort
      silent! colorscheme two-firewatch
    endfunction

    let s:cpo_save = &cpoptions
    set cpoptions&vim

    nnoremap <silent><special> <Leader>zt
          \ :<C-U>call <SID>Firewatch()<CR>:set bg=light<CR>

    let &cpoptions = s:cpo_save
    unlet s:cpo_save

  endif
endif

augroup dkocolorscheme
  autocmd! VimEnter * nested silent! execute 'colorscheme meh'
augroup END

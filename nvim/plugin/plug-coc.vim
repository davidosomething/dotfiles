" plugin/coc.vim

augroup dkococ
  autocmd!
augroup END

if !dkoplug#IsLoaded('coc.nvim')
  finish
endif

" --------------------------------------------------------------------------
" Settings
" --------------------------------------------------------------------------

" coc-snippets
let g:coc_snippet_next = '' "'<C-f>'
let g:coc_snippet_prev = '' "'<C-b>'

" --------------------------------------------------------------------------
" Mappings
" --------------------------------------------------------------------------

let s:cpo_save = &cpoptions
set cpoptions&vim

inoremap <silent><expr> <C-Space> coc#refresh()

" Function textobjs
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Action
nmap <leader>qf  <Plug>(coc-fix-current)

" Formatting
nmap <silent> <Leader>= <Plug>(coc-format-selected)
vmap <silent> <Leader>= <Plug>(coc-format-selected)

" coc-snippets
imap <C-f> <Plug>(coc-snippets-expand-jump)

let &cpoptions = s:cpo_save
unlet s:cpo_save

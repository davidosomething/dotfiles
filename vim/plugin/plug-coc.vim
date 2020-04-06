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

let g:coc_enable_locationlist = 0

autocmd dkococ FileType css,less,scss
      \ let b:coc_additional_keywords = ['-']

" coc-snippets
let g:coc_snippet_next = '' "'<C-f>'
let g:coc_snippet_prev = '' "'<C-b>'

" --------------------------------------------------------------------------
" Utils
" --------------------------------------------------------------------------

let s:vim_help = ['vim', 'help']
function! s:ShowDocumentation()
  if (index(s:vim_help, &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" --------------------------------------------------------------------------
" Mappings
" --------------------------------------------------------------------------

let s:cpo_save = &cpoptions
set cpoptions&vim

inoremap <silent><expr> <C-Space> coc#refresh()

nnoremap <silent> K :<C-U>call <SID>ShowDocumentation()<CR>

" Function textobjs
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Action
nmap <silent> <Leader>ca <Plug>(coc-codeaction)

" Diagnostics
nmap <silent> <Leader>d <Plug>(coc-diagnostic-info)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [d <Plug>(coc-diagnostic-prev)

" Code navigation
nmap <silent> gh <Plug>(coc-declaration)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> <Leader>t <Plug>(coc-type-definition)

" Formatting
nmap <silent> <Leader>= <Plug>(coc-format-selected)
vmap <silent> <Leader>= <Plug>(coc-format-selected)

nmap <silent> <Leader>bc <Plug>(coc-calc-result-replace)

" coc-git
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)

" coc-prettier
autocmd dkococ FileType
      \ javascript,javascriptreact,typescript,typescriptreact,json,graphql
      \ nmap <silent> <A-=>
      \   :<C-u>CocCommand prettier.formatFile<CR>
      "\   :CocCommand eslint.executeAutofix<CR>

" coc-snippets
imap <C-f> <Plug>(coc-snippets-expand-jump)

let &cpoptions = s:cpo_save
unlet s:cpo_save

" --------------------------------------------------------------------------
" Autorun
" --------------------------------------------------------------------------

autocmd dkococ CursorHold * silent call CocActionAsync('highlight')

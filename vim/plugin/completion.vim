" plugin/completion.vim

augroup dkocompletion
  autocmd!
augroup END

if !dkoplug#IsLoaded('coc.nvim')
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" coc.nvim
" ============================================================================

if dkoplug#IsLoaded('coc.nvim')
  call coc#add_extension(
        \  'coc-css',
        \  'coc-diagnostic',
        \  'coc-eslint',
        \  'coc-git',
        \  'coc-html',
        \  'coc-json',
        \  'coc-prettier',
        \  'coc-pyright',
        \  'coc-snippets',
        \  'coc-solargraph',
        \  'coc-syntax',
        \  'coc-tsserver',
        \  'coc-vimlsp',
        \  'coc-webpack',
        \  'coc-yaml'
        \)

  " Not working
  "      \  'coc-python',
  "      \  'coc-java',
  " Doesn't redraw in sync with edits
  "\  'coc-highlight',

  let g:coc_enable_locationlist = 0
  let g:coc_snippet_next = '<C-f>'
  let g:coc_snippet_prev = '<C-b>'

  function! s:ShowDocumentation()
    if &filetype ==# 'vim'
      execute 'h ' . expand('<cword>')
    else
      call CocActionAsync('doHover')
    endif
  endfunction

  inoremap <silent><expr> <C-Space> coc#refresh()

  " Function textobjs
  xmap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap if <Plug>(coc-funcobj-i)
  omap af <Plug>(coc-funcobj-a)

  nmap <silent> <Leader>d <Plug>(coc-diagnostic-info)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)
  nmap <silent> [d <Plug>(coc-diagnostic-prev)

  nmap <silent> gh <Plug>(coc-declaration)

  " value
  nmap <silent> gd <Plug>(coc-definition)

  " instance
  nmap <silent> gi <Plug>(coc-implementation)

  nmap <silent> <Leader>t <Plug>(coc-type-definition)
  nnoremap <silent> K :<C-U>call <SID>ShowDocumentation()<CR>

  nmap <silent> <Leader>= <Plug>(coc-format-selected)
  vmap <silent> <Leader>= <Plug>(coc-format-selected)

  autocmd dkocompletion FileType
        \ javascript,javascriptreact,typescript,typescriptreact,json,graphql
        \ nmap <silent> <A-=>
        \   :<C-u>CocCommand prettier.formatFile<CR>
        "\   :CocCommand eslint.executeAutofix<CR>

  autocmd dkocompletion FileType css,less,scss
        \ let b:coc_additional_keywords = ['-']

  " coc-git
  nmap [g <Plug>(coc-git-prevchunk)
  nmap ]g <Plug>(coc-git-nextchunk)
endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

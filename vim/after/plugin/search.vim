" after/plugin/search.vim
"
" This is an after/plugin since some plugins (in testing, like vim-searchant)
" might set their own mappings.

if exists('g:loaded_dko_search') | finish | endif
let g:loaded_dko_search = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" Native incsearch
" ============================================================================

" Tab/S-Tab go to next match while still in cmdline
cnoremap <special><expr> <Tab>    getcmdtype() =~ '[?/]'
      \ ? '<C-g>' : feedkeys('<Tab>', 'int')[1]
cnoremap <special><expr> <S-Tab>  getcmdtype() =~ '[?/]'
      \ ? '<C-t>' : feedkeys('<S-Tab>', 'int')[1]

" ============================================================================

if !dkoplug#IsLoaded('vim-asterisk') | finish | endif

" In case some other plugin tries something fishy
silent! unmap /
silent! unmap g/
silent! unmap ?
silent! unmap *
silent! unmap g*
silent! unmap #
silent! unmap g#
silent! unmap n
silent! unmap N

let g:asterisk#keeppos = 1

" @param  {String} op for asterisk
" @return {String} <expr>
function! s:GetSearchRHS(op) abort
  return '<Plug>(asterisk-' . a:op . ')'
endfunction
" the "z" means stay on the first match instead of autojump to next
execute 'map <special> * ' . s:GetSearchRHS('z*')
execute 'map <special> # ' . s:GetSearchRHS('z#')
execute 'map <special> g* ' . s:GetSearchRHS('gz*')
execute 'map <special> g# ' . s:GetSearchRHS('gz#')

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

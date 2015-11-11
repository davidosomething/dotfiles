" Disable AutoComplPop.
let g:acp_enableAtStartup = 0

let g:deoplete#enable_at_startup            = 1
let g:deoplete#enable_smart_case            = 1
let g:deoplete#enable_camel_case            = 1
let g:deoplete#enable_fuzzy_completion      = 0
let g:deoplete#data_directory = '~/.vim/.cache/deoplete'

" completion sources
let g:deoplete#sources#syntax#min_keyword_length = 3

" enable heavy completion
if !exists('g:deoplete#sources#omni#input_patterns')
  let g:deoplete#sources#omni#input_patterns = {}
endif

" CRASH HEAVY OMNICOMPLETE
let g:deoplete#sources#omni#input_patterns.ruby = ''
let g:deoplete#sources#omni#input_patterns.python = ''

let g:deoplete#sources#omni#input_patterns.typescript =
      \ '[^. \t]\.\%(\h\w*\)\?'

if !exists('g:deoplete#force_omni_input_patterns')
  let g:deoplete#force_omni_input_patterns = {}
endif
" Use omnifunc for javascript completion since we have tern
"let g:deoplete#force_omni_input_patterns.javascript = '[^. \t]\.\w*'

" from the github page: <CR> cancels completion and inserts newline
inoremap <silent><CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  " v2.1
  "return deoplete#close_popup() . "\<CR>"

  " v next
  return (pumvisible() ? "\<C-y>" : "") . "\<CR>"
  "return pumvisible() ? "\<C-y>" : "\<CR>"
  "return "\<C-y>\<CR>"
endfunction

" These are in deoplete#mappings#define_default_mappings()
" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

" select completion using tab
let g:IndentTab_IsSuperTab = 1
inoremap <expr><Tab>   pumvisible()
      \ ? "\<C-n>"
      \ : IndentTab#Tab()
"\<TAB>"
inoremap <expr><S-Tab> pumvisible()
      \ ? "\<C-p>"
      \ : "\<S-Tab>"

" re-open completion with c-space
" @see <https://github.com/Shougo/deoplete.vim/issues/33#issuecomment-20732569>
inoremap <expr><C-Space>        deoplete#start_manual_complete('omni')

" completion
autocmd vimrc FileType css           setlocal omnifunc=csscomplete#CompleteCSS
autocmd vimrc FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd vimrc FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
" built-in, also phpcomplete-extended provides support
" @see <https://github.com/shawncplus/phpcomplete.vim/issues/55#issuecomment-72163856>
"autocmd vimrc FileType php setlocal omnifunc=phpcomplete#CompletePHP
autocmd vimrc FileType python        setlocal omnifunc=pythoncomplete#Complete
autocmd vimrc FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
autocmd vimrc FileType ruby          setlocal omnifunc=rubycomplete#Complete

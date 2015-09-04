let g:neocomplete#enable_at_startup            = 1
let g:neocomplete#enable_smart_case            = 1
let g:neocomplete#enable_camel_case            = 1
let g:neocomplete#enable_fuzzy_completion      = 0
let g:neocomplete#data_directory = '~/.vim/.cache/neocomplete'

" completion sources
let g:neocomplete#sources#syntax#min_keyword_length = 3

" enable heavy completion
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

" CRASH HEAVY OMNICOMPLETE
let g:neocomplete#sources#omni#input_patterns.ruby = ''
let g:neocomplete#sources#omni#input_patterns.python = ''

" from neocomplete docs -- phpcomplete.vim integration
let g:neocomplete#sources#omni#input_patterns.php =
  \ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

let g:neocomplete#sources#omni#input_patterns.typescript = '[^. \t]\.\%(\h\w*\)\?'

if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
" Use omnifunc for javascript completion since we have tern
"let g:neocomplete#force_omni_input_patterns.javascript = '[^. \t]\.\w*'

" from the github page: <CR> cancels completion and inserts newline
inoremap <silent><CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
endfunction

" These are in neocomplete#mappings#define_default_mappings()
" <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0

" select completion using tab
inoremap <expr><Tab>      pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-Tab>    pumvisible() ? "\<C-p>" : "\<S-Tab>"

" completion
au vimrc FileType css           setlocal omnifunc=csscomplete#CompleteCSS
au vimrc FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
au vimrc FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
au vimrc FileType python        setlocal omnifunc=pythoncomplete#Complete
au vimrc FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
au vimrc FileType ruby          setlocal omnifunc=rubycomplete#Complete
